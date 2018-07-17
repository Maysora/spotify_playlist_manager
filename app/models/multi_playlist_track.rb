# == Schema Information
#
# Table name: multi_playlist_tracks
#
#  id                         :bigint(8)        not null, primary key
#  multi_playlist_id          :bigint(8)        not null
#  spotify_id                 :string
#  spotify_uri                :string
#  source_playlist_spotify_id :string
#  name                       :string
#  album_name                 :string
#  artist_name                :string
#  local                      :boolean          default(FALSE), not null
#  last_sync_at               :datetime         not null
#

class MultiPlaylistTrack < ApplicationRecord
  belongs_to :multi_playlist

  validates :multi_playlist, :last_sync_at, presence: true

  scope :expired_at, -> (time) { where(local: false).where('last_sync_at < ?', time) }

  def playlist_track=(playlist_track)
    self.attributes = {
      local: playlist_track.is_local
    }
    self.track = playlist_track.track
  end

  def track=(track)
    if track.nil?
      self.attributes = {
        spotify_id: nil,
        spotify_uri: nil,
        name: nil,
        album_name: nil,
        artist_name: nil
      }
    else
      self.attributes = {
        spotify_id: track.id,
        spotify_uri: track.uri,
        name: track.name,
        album_name: track.album.try(:name),
        artist_name: track.artists.map(&:name).join(', ')
      }
    end
  end
end
