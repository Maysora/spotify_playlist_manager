class SpotifyConfiguration < ApplicationRecord
  belongs_to :user

  def token
    token_expired? ? refresh_token! : super
  end

  def refresh_token!
    raise 'TODO: implement refresh token api'
    # POST https://accounts.spotify.com/api/token
    body = {
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    }
  end

  def token_expired?
    1.minute.from_now >= expires_at
  end
end
