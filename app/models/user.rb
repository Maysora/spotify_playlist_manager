# == Schema Information
#
# Table name: users
#
#  id                 :bigint(8)        not null, primary key
#  nickname           :string
#  email              :string           default(""), not null
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :inet
#  last_sign_in_ip    :inet
#  provider           :string
#  uid                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  spotify_id         :string
#

class User < ApplicationRecord
  devise :trackable
  devise :omniauthable, omniauth_providers: %i[spotify]

  has_one :spotify_configuration
  has_many :multi_playlists, dependent: :destroy

  delegate :token, to: :spotify_configuration, prefix: :spotify, allow_nil: true

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.update(
      email: auth.info.email,
      nickname: auth.info.nickname,
      spotify_id: auth.uid)
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
