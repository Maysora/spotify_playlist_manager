namespace :playlist do
  task "sync" => :environment do
    MultiPlaylist.find_each(&:schedule_sync_playlists)
  end
end
