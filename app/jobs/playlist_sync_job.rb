class PlaylistSyncJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Do nothing as the record no longer present
  end

  def perform(multi_playlist)
    auth_spotify_user(multi_playlist.user)
    multi_playlist.sync_playlists
  end
end
