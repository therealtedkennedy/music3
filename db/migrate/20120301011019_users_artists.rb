class UsersArtists < ActiveRecord::Migration
  def self.up
    create_table :users_artists, :id => false do |t|
         t.integer :user_id
         t.integer :artist_id
     end
  end

  def self.down
    drop_table :users_artists
  end
end
