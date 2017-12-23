class SpotifyApi::Playlist < SpotifyApi::Base
  self.site = "https://api.spotify.com/v1/me"

  def self.default_per_page
    50
  end

  def tracks
    SpotifyApi::PlaylistTrack.all(params: {user_id: owner.id, playlist_id: id})
  end

  def tracks_count
    attributes['tracks'].total
  end

  def to_param
    "#{owner.id}>#{id}"
  end

  def self.find_single(scope, options)
    options[:from] = "/v1/users/#{options.delete(:user_id)}/playlists/#{scope}"
    find_one(options)
  end

  protected

  def validate
    errors.add(:base, "Read-only")
  end
end
