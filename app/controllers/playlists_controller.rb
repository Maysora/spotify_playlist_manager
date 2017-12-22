class PlaylistsController < ApplicationController
  def index
    @playlists = current_user.playlists(page: params[:page])
  end
end
