# Spotify API Wrapper
# TODO:
# - playlist APIs (https://developer.spotify.com/web-api/endpoint-reference/)
# - - https://beta.developer.spotify.com/console/get-current-user-playlists/
# - - https://beta.developer.spotify.com/console/get-playlist-tracks/
# - - https://beta.developer.spotify.com/console/post-playlist-followers-contains/
# - - https://beta.developer.spotify.com/console/post-playlist-tracks/
# - handle API errors (https://developer.spotify.com/web-api/user-guide/#responses) using resp.code
# - use async job to handle rate limiting (https://developer.spotify.com/web-api/user-guide/#rate-limiting)
class SpotifyApi
  include HTTParty
  base_uri 'https://accounts.spotify.com/api'

  attr_reader :options

  def initialize(client_id: ENV['SPOTIFY_CLIENT_ID'], client_secret: ENV['SPOTIFY_CLIENT_SECRET'])
    @options = { basic_auth: { username: client_id, password: client_secret } }
  end

  def token(refresh_token:)
    resp = self.class.post("/token", options.merge(
            body: {
              grant_type: 'refresh_token',
              refresh_token: refresh_token}))
    if resp.success?
      resp.parsed_response
    else
      response_error(resp)
    end
  end

  private

  def response_error(resp)
    case resp.code
    when 400
      raise RequestError.new(resp)
    # when 401 # invalid token
    # when 403
    # when 404
    # when 429 # rate limited
    else
      raise Error.new("Unexpected error: #{resp.inspect}")
    end
  end

  class Error < ::StandardError ; end
  class RequestError < Error
    attr_reader :code, :body

    def initialize(data)
      @code = data.code
      @body = data.parsed_response
    end

    def to_s
      code.to_s + (body['error_description'].presence || @body['error'].try(:[], 'message'))
    end
  end
end
