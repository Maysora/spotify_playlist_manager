# Spotify Playlist Manager

Rails application for managing playlists on spotify.

This is a personal weekend project so progress will be slow ;)

# Goals

- ~~OAuth login~~
- ~~Displaying playlists~~
- ~~Displaying playlist tracks~~
- Adding/removing tracks from playlist
- Multiple Playlist
    + ~~Model~~
    + Controller
        * Create
        * ~~Update~~
        * Destroy
    + ~~Sync process~~
    + Scheduling
- Nicer UI (Use React?)
- ???

# TODO

- Probably should throw away active resource and use net http directly..
- Tests

# ENV variables

- RACK_ENV
- RAILS_ENV
- DATABASE_HOST
- DATABASE_USERNAME
- DATABASE_PASSWORD
- RAILS_MAX_THREADS
- APP_HOST
- PORT
- APP_EMAIL
- SPOTIFY_CLIENT_ID
- SPOTIFY_CLIENT_SECRET
- JOB_WORKER_URL

# Deployment (Using Capistrano)

- Copy and modify these example files: `Capfile.example`, `config/deploy.rb.example`, `config/deploy/production.rb.example`
- Configure your server according to https://capistranorb.com/documentation/getting-started/authentication-and-authorisation/
```
deploy_to=/var/www/spotify_manager
mkdir -p ${deploy_to}
chown deploy:deploy ${deploy_to}
umask 0002
chmod g+s ${deploy_to}
mkdir ${deploy_to}/{releases,shared}
chown deploy ${deploy_to}/{releases,shared}
```
- Copy and modify `.env.example` to your server `/var/www/spotify_manager/shared/.env` (or `.rbenv-vars` if using rbenv)
- Makes sure your server has everything required:
    + Ruby 2.4.x with bundler gem
    + Postgresql
    + Puma with nginx (or other web server)
    + Redis
- `cap production puma:config` or `cap production puma:jungle:config`
- `cap production initial` for the first time or `cap production deploy` to update
