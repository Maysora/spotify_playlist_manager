class CreateSpotifyConfigurations < ActiveRecord::Migration[5.1]
  def change
    create_table :spotify_configurations do |t|
      t.belongs_to :user, index: {unique: true}, null: false
      t.string     :token, null: false
      t.string     :refresh_token
      t.datetime   :expires_at
      t.timestamps
    end
  end
end
