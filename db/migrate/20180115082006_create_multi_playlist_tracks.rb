class CreateMultiPlaylistTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :multi_playlist_tracks do |t|
      t.belongs_to :multi_playlist, index: true, null: false
      t.string     :spotify_id # nil for local file
      t.string     :spotify_uri
      t.string     :source_playlist_spotify_id # nil when added by other app
      t.string     :name
      t.string     :album_name
      t.string     :artist_name
      t.boolean    :local, default: false, null: false
      t.datetime   :last_sync_at, null: false
    end
  end
end
