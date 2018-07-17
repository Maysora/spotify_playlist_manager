# Spotify API Base Model
# TODO:
# - handle API errors (https://developer.spotify.com/web-api/user-guide/#responses)
# - - https://github.com/rails/activeresource/blob/v5.0.0/lib/active_resource/base.rb#L191
# - use async job to handle rate limiting (https://developer.spotify.com/web-api/user-guide/#rate-limiting)
class SpotifyApi::Base < ActiveResource::Base
  self.site = "https://api.spotify.com/v1"
  self.include_format_in_path = false
  self.collection_parser = SpotifyApi::PaginatedCollection
  class << self
    alias_method :headers_without_authorization, :headers
    def headers_with_authorization
      if token.present?
        headers_without_authorization.merge('Authorization' => "Bearer #{token}")
      else
        headers_without_authorization
      end
    end
    alias_method :headers, :headers_with_authorization

    private

    def token
      RequestStore.store['current_user_spotify_token']
    end
  end
  headers['Content-Type'] = 'application/json'

  # override to simplify pagination
  def self.all(*args)
    if (params = args[0].try(:[], :params))
      limit = (params[:limit] ||= self.default_per_page).to_i
      if (page = params.delete(:page))
        params[:offset] = [(page.to_i - 1), 0].max * limit
      end
    end
    super *args
  end

  def self.default_per_page
    20
  end
end

class SpotifyApi::MethodNotAllowed < StandardError ; end
