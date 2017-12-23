class TracksController < ApplicationController
  def index
    @tracks = SpotifyApi::PlaylistTrack.all(params: { page: params[:page], playlist_id: params[:playlist_id], user_id: current_user.spotify_id })
  end
end
