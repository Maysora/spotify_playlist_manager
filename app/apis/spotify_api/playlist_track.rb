class SpotifyApi::PlaylistTrack < SpotifyApi::Base
  self.site = "https://api.spotify.com/v1/users/:user_id/playlists/:playlist_id"
  self.collection_name = 'tracks'

  def self.default_per_page
    100
  end

  def self.destroy(user_id:, playlist_id:, tracks:)
    tracks.each_slice(100) do |tracks_group|
      new(user_id: user_id, playlist_id: playlist_id, tracks: tracks_group).destroy
    end
  end

  # override to add body on delete request
  def destroy
    run_callbacks :destroy do
      connection.delete(element_path, encode, self.class.headers)
    end
  end

  protected

  def validate
    errors.add(:base, "Read-only")
  end
end
