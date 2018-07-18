# == Schema Information
#
# Table name: multi_playlists
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)        not null
#  spotify_id   :string           not null
#  owner_id     :string           not null
#  name         :string
#  description  :text
#  image_url    :string
#  public       :boolean          default(FALSE), not null
#  tracks_count :integer
#  playlist_ids :string           default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class MultiPlaylist < ApplicationRecord
  belongs_to :user
  has_many :tracks, class_name: 'MultiPlaylistTrack', dependent: :destroy

  before_validation :create_on_spotify, unless: :spotify_id?, on: [:create]
  after_commit :schedule_sync_playlists, if: -> (r) { r.previous_changes.has_key?(:playlist_ids) }, on: [:create, :update]

  validates :name, :user, :spotify_id, :owner_id, presence: true

  delegate :spotify_id, to: :user, prefix: true, allow_nil: true

  def self.create_with_spotify_id spotify_id, owner_id
    fields = %w(id owner.id name description images public tracks.total).join(',')
    playlist = SpotifyApi::Playlist.find(spotify_id, params: {user_id: owner_id, fields: fields})
    create(playlist: playlist)
  end

  def playlist=(playlist)
    @playlist = playlist
    self.attributes = {
      spotify_id: playlist.id,
      owner_id: playlist.owner.id,
      name: playlist.name,
      description: playlist.description,
      image_url: playlist.images.first.try(:url),
      public: playlist.public,
      tracks_count: playlist.tracks_count
    }
  end

  def playlist
    @playlist ||= SpotifyApi::Playlist.find(spotify_id, params: {user_id: owner_id})
  end

  def add_tracks(playlist_id:, user_id:, time: DateTime.now)
    playlist_tracks = SpotifyApi::PlaylistTrack.all(params: {user_id: user_id, playlist_id: playlist_id})
    new_tracks = []
    existing_tracks = []
    while playlist_tracks
      playlist_tracks.each do |playlist_track|
        next if playlist_track.is_local # Unable to add local file from web API (https://developer.spotify.com/web-api/local-files-spotify-playlists/)
        next if playlist_track.track.nil? # don't have track information
        track = tracks.detect { |t| t.spotify_id == playlist_track.track.id }
        if track
          existing_tracks << track
        else
          track = tracks.create(spotify_id: playlist_track.track.id, playlist_track: playlist_track, last_sync_at: time, source_playlist_spotify_id: playlist_id)
          new_tracks << track
        end
      end
      playlist_tracks = playlist_tracks.next
    end

    new_tracks.each_slice(20) do |tracks|
      PlaylistTrackSyncJob.perform_later('create', self, tracks)
    end if playlist_id != spotify_id

    tracks.where(id: existing_tracks.map(&:id)).update_all(last_sync_at: time) if existing_tracks.present?
  end

  def clean_up_at(time = DateTime.now)
    expired_tracks = tracks
                      .expired_at(time)
                      .where('spotify_uri IS NOT NULL') # filter out invalid track
    expired_tracks.find_in_batches(batch_size: 20) do |tracks|
      PlaylistTrackSyncJob.perform_later('delete', self, tracks)
    end
  end

  def sync_playlists
    copy_tracks # makes sure all tracks in spotify exists here
    time = DateTime.now
    Array(playlist_ids).each do |playlist_id|
      user_id, _sep, playlist_id = playlist_id.rpartition('>')
      add_tracks(playlist_id: playlist_id, user_id: user_id, time: time)
    end
    clean_up_at(time)
  end

  def schedule_sync_playlists
    PlaylistSyncJob.perform_later(self)
  end

  def playlist_ids=(value)
    super value.reject(&:blank?)
  end

  private

  def create_on_spotify
    if user_spotify_id.present?
      self.playlist = SpotifyApi::Playlist.create(user_id: user_spotify_id, name: name, description: description, public: public?)
    end
    true
  end

  def copy_tracks
    add_tracks(playlist_id: spotify_id, user_id: owner_id)
  end
end
