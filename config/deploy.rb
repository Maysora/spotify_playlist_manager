# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "spotify_manager"
set :repo_url, "https://github.com/Maysora/spotify_playlist_manager.git"

set :conditionally_migrate, true
set :keep_assets, 2
set :keep_releases, 2
set :migration_role, :app

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.4.4'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails whenever puma pumactl sidekiq sidekiqctl}

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_environment, fetch(:stage)
set :whenever_variables, -> do
  "'environment=#{fetch :whenever_environment}" \
  "&rbenv_root=#{fetch :rbenv_path}" \
  "&rbenv_version=#{fetch :rbenv_ruby}'"
end

set :puma_jungle_conf, '/etc/puma.conf'
set :puma_run_path, '/usr/local/bin/run-puma'
set :puma_init_active_record, true

set :sidekiq_config, 'config/sidekiq.yml'

append :linked_files, '.rbenv-vars'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', '.bundle'

namespace :db do
  desc 'Create db'
  task :create do
    on primary :db do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:create'
        end
      end
    end
  end
end

desc 'Initial Deploy'
task :initial do
  on roles(:app) do
    before 'deploy:migrate', 'db:create'
    invoke 'puma:config'
    invoke 'deploy'
  end
end
