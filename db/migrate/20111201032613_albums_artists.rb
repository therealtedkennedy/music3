class AlbumsArtists < ActiveRecord::Migration
  def self.up
    create_table :albums_artists, :id => false do |t|
         t.integer :album_id
         t.integer :artist_id
     end
  end

  def self.down
    drop_table :albums_artists
  end
end
