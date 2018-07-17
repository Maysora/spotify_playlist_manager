# == Schema Information
#
# Table name: multi_playlists
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)        not null
#  spotify_id   :string           not null
#  owner_id     :string           not null
#  name         :string
#  description  :text
#  image_url    :string
#  public       :boolean          default(FALSE), not null
#  tracks_count :integer
#  playlist_ids :string           default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class MultiPlaylistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
