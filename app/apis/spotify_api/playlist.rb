class SpotifyApi::Playlist < SpotifyApi::Base
  # self.site = "https://api.spotify.com/v1/me"
  self.site = "https://api.spotify.com/v1/users/:user_id"

  def self.default_per_page
    50
  end

  def get_tracks
    SpotifyApi::PlaylistTrack.all(params: {user_id: owner.id, playlist_id: id})
  end

  def tracks_count
    attributes['tracks'].total
  end

  def to_param
    "#{owner.id}>#{id}"
  end

  def self.find_for_multi_playlist(spotify_id:, owner_id:)
    fields = %w(id owner.id name description images public tracks.total).join(',')
    find(spotify_id, {user_id: owner_id, fields: fields})
  end

  def self.find_every(options)
    options[:from] ||= "/v1/me/playlists"
    super options
  end

  def destroy
    raise SpotifyApi::MethodNotAllowed.new('Playlist removal not supported in web API')
  end

  protected

  def validate
    errors.add(:base, "Read-only")
  end
end
