# == Schema Information
#
# Table name: multi_playlist_tracks
#
#  id                         :bigint(8)        not null, primary key
#  multi_playlist_id          :bigint(8)        not null
#  spotify_id                 :string
#  spotify_uri                :string
#  source_playlist_spotify_id :string
#  name                       :string
#  album_name                 :string
#  artist_name                :string
#  local                      :boolean          default(FALSE), not null
#  last_sync_at               :datetime         not null
#

require 'test_helper'

class MultiPlaylistTrackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
