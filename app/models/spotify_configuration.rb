# == Schema Information
#
# Table name: spotify_configurations
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)        not null
#  token         :string           not null
#  refresh_token :string
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class SpotifyConfiguration < ApplicationRecord
  belongs_to :user

  # TODO: properly schedule refresh instead
  def token
    refresh_token! if token_expired?
    super
  end

  def refresh_token!
    data = spotify_api.token(refresh_token: refresh_token)
    update!(token: data['access_token'], expires_at: data['expires_in'].seconds.from_now)
  end

  def token_expired?
    1.minute.from_now >= expires_at
  end

  private

  def spotify_api
    @spotify_api ||= SpotifyApi.new
  end
end
