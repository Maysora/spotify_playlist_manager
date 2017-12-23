class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_spotify_api_auth, if: :user_signed_in?

  rescue_from ActiveResource::ClientError, with: :handle_api_client_error

  private

  def set_spotify_api_auth
    if current_user.spotify_token.present?
      RequestStore.store['current_user_spotify_token'] = current_user.spotify_token
    else
      sign_out
      redirect_to root_path, alert: 'Problem with spotify token, please re-login.'
    end
  end

  def after_sign_in_path_for(resource)
    playlists_path
  end

  def handle_api_client_error(exception)
    message = begin
      h = JSON.parse(exception.response.body)
      "API client error: #{h['error'].try(:[], 'message').presence || h['error_description']}"
    rescue JSON::ParserError
      exception.to_s
    end
    redirect_to root_path, alert: message
  end


  # helper


  def spotify_api_id id
    user_id, _sep, id = id.rpartition('>')
    [id, user_id]
  end
end
