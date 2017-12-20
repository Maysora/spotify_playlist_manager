class User < ApplicationRecord
  devise :trackable
  devise :omniauthable, omniauth_providers: %i[spotify]

  has_one :spotify_configuration

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.nickname = auth.info.nickname
    end
    user.update_spotify_configuration!(auth.credentials) if user.persisted?
    user
  end

  def update_spotify_configuration!(credentials)
    (spotify_configuration || build_spotify_configuration).update!(
      token: credentials.token,
      refresh_token: credentials.refresh_token,
      expires_at: Time.at(credentials.expires_at))
  end
end
