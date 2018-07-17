class PlaylistTrackSyncJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Do nothing as the record no longer present
  end

  def perform(action, multi_playlist, tracks)
    case action.to_s
    when 'create'
      create_on_spotify(multi_playlist, tracks)
    when 'delete'
      delete_on_spotify(multi_playlist, tracks)
    end
  end

  private

  # https://developer.spotify.com/web-api/add-tracks-to-playlist/
  def create_on_spotify(multi_playlist, tracks)
    auth_spotify_user(multi_playlist.user)
    uris = tracks.map(&:spotify_uri).compact
    SpotifyApi::PlaylistTrack.create(user_id: multi_playlist.owner_id, playlist_id: multi_playlist.spotify_id, uris: uris)
  end

  # https://developer.spotify.com/web-api/remove-tracks-playlist/
  def delete_on_spotify(multi_playlist, tracks)
    auth_spotify_user(multi_playlist.user)
    api_tracks = tracks.map { |track|
      if track.spotify_uri.present?
        { uri: track.spotify_uri }
      else
        nil
      end
    }.compact
    SpotifyApi::PlaylistTrack.destroy(user_id: multi_playlist.owner_id, playlist_id: multi_playlist.spotify_id, tracks: api_tracks)
    tracks.each(&:destroy)
  end
end
