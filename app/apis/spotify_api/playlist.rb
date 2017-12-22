class SpotifyApi::Playlist < SpotifyApi::Base
  self.site = "https://api.spotify.com/v1/me"

  def tracks
    SpotifyApi::PlaylistTrack.all(params: {user_id: owner.id, playlist_id: id})
  end

  def tracks_count
    attributes['tracks'].total
  end

  def self.default_per_page
    50
  end

  protected

  def validate
    errors.add(:base, "Read-only")
  end
end
