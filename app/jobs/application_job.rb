class ApplicationJob < ActiveJob::Base

  private

  def auth_spotify_user(user)
    RequestStore.store['current_user_spotify_token'] = user.spotify_token
  end
end
