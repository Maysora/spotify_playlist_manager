class MultiPlaylistsController < ApplicationController
  def new
  end

  def create
  end

  def edit
    @multi_playlist = current_user.multi_playlists.find(params[:id])
    @playlists = prepare_user_playlists exclude_ids: @multi_playlist.spotify_id
  end

  def update
    @multi_playlist = current_user.multi_playlists.find(params[:id])
    if @multi_playlist.update! multi_playlist_params
      redirect_to playlists_path, notice: 'Updated. Synchronizing tracks might take several minutes.'
    else
      render 'edit'
    end
  end

  private

  # TODO: caching
  def prepare_user_playlists(exclude_ids: [])
    playlists = []
    SpotifyApi::Playlist.all.find_each do |ps|
      playlists += ps
    end
    playlists.reject! { |p| exclude_ids.include?(p.id) }
    playlists
  end

  def multi_playlist_params
    params
      .require(:multi_playlist)
      .permit(playlist_ids: [])
  end
end
