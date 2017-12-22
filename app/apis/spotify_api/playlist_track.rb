# WIP: unchecked
class SpotifyApi::PlaylistTrack < SpotifyApi::Base
  self.site = "https://api.spotify.com/v1/users/:user_id/playlists/:playlist_id"
  self.collection_name = 'tracks'

  def self.default_per_page
    100
  end

  protected

  def validate
    errors.add(:base, "Read-only")
  end
end
