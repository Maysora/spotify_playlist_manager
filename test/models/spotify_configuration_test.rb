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

require 'test_helper'

class SpotifyConfigurationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
