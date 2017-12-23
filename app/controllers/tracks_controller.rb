class TracksController < ApplicationController
  def index
    playlist_id, user_id = spotify_api_id(params[:playlist_id])
    @tracks = SpotifyApi::PlaylistTrack.all(params: { page: params[:page], playlist_id: playlist_id, user_id: user_id })
  end
end
