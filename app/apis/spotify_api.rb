# Spotify API Wrapper
# TODO:
# - handle API errors (https://developer.spotify.com/web-api/user-guide/#responses)
# - use async job to handle rate limiting (https://developer.spotify.com/web-api/user-guide/#rate-limiting)
require 'net/https'
require 'uri'

class SpotifyApi
  attr_reader :options

  def initialize(client_id: ENV['SPOTIFY_CLIENT_ID'], client_secret: ENV['SPOTIFY_CLIENT_SECRET'])
    @basic_auth = [client_id, client_secret]
  end

  def token(refresh_token:)
    req = Net::HTTP::Post.new('/api/token')
    req.set_form_data({
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    })
    res = request(req)
    if res.code =~ /\A2\d+/
      JSON.parse(res.body)
    elsif res.code =~ /\A4\d+/
      body = JSON.parse(res.body)
      raise RequestError.new(res.code + (body['error_description'].presence || @body['error'].try(:[], 'message')))
    else
      raise Error.new("Unexpected error when refreshing token (#{res.code}): #{res.body}")
    end
  rescue Timeout::Error => e
    raise
  rescue OpenSSL::SSL::SSLError => e
    raise
  end

  def request(req)
    req.basic_auth *@basic_auth
    http.request(req)
  end

  private

  def http(uri = URI('https://accounts.spotify.com'))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = http.read_timeout = 20.seconds
    http
  end

  class Error < ::StandardError ; end
  class RequestError < Error ; end
end
