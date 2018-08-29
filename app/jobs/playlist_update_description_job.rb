class PlaylistUpdateDescriptionJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Do nothing as the record no longer present
  end

  def perform(multi_playlist)
    auth_spotify_user(multi_playlist.user)

    names = Array(multi_playlist.playlist_ids).map do |playlist_id|
      user_id, _sep, playlist_id = playlist_id.rpartition('>')
      SpotifyApi::Playlist.find(playlist_id, params: {user_id: user_id, fields: 'name'}).try(:name)
    end.compact
    description = "MultiPlaylist: " + names.join(', ')

    multi_playlist.playlist.update_attributes(description: description) &&
      multi_playlist.update_column(:description, description)
  end
end
