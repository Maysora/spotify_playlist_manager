class PlaylistsController < ApplicationController
  def index
    @playlists = SpotifyApi::Playlist.all(params: { page: params[:page] })
  end

  # not necessary?
  def show
    id, user_id = spotify_api_id(params[:id])
    @playlist = SpotifyApi::Playlist.find(id, {user_id: current_user.spotify_id})
  end
end
