class PlaylistsController < ApplicationController
  def index
    @playlists = SpotifyApi::Playlist.all(params: { page: params[:page] })
  end

  # not necessary?
  def show
    @playlist = SpotifyApi::Playlist.find(params[:id], {user_id: current_user.spotify_id})
  end
end
