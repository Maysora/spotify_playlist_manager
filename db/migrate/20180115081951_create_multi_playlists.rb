class CreateMultiPlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :multi_playlists do |t|
      t.belongs_to :user, index: true, null: false
      t.string     :spotify_id, null: false
      t.string     :owner_id, null: false
      t.string     :name
      t.text       :description
      t.string     :image_url
      t.boolean    :public, default: false, null: false
      t.integer    :tracks_count
      t.string     :playlist_ids, array: true, default: []
      t.timestamps
    end
  end
end
