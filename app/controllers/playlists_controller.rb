class PlaylistsController < ApplicationController
  def index
    @playlists = SpotifyApi::Playlist.all(params: { page: params[:page] })
    # [{spotify_id => id}, {...}, ...]
    @multi_playlist_ids = Hash[*current_user.multi_playlists.where(spotify_id: @playlists.map(&:id)).pluck(:spotify_id, :id).flatten(1)]
  end

  # not necessary?
  def show
    id, user_id = spotify_api_id(params[:id])
    @playlist = SpotifyApi::Playlist.find(id, params: {user_id: current_user.spotify_id})
  end
end
