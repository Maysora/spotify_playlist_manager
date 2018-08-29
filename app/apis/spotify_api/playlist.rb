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

  # https://developer.spotify.com/documentation/web-api/reference/playlists/change-playlist-details/
  def update_attributes(attributes)
    load(attributes, false) &&
      run_callbacks(:save) do
        run_callbacks(:update) do
          filtered_attributes = attributes.keys.map(&:to_sym) & updatable_attributes
          connection.put("/v1/users/a/playlists/#{id}", encode(only: filtered_attributes), self.class.headers).tap do |response|
            load_attributes_from_response(response)
          end
        end
      end
  end

  def destroy
    raise SpotifyApi::MethodNotAllowed.new('Playlist removal not supported in web API')
  end

  protected

  def validate
    errors.add(:base, "Read-only")
  end

  def updatable_attributes
    [:name, :public, :collaborative, :description]
  end
end
