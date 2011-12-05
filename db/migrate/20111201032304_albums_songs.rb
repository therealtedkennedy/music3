class AlbumsSongs < ActiveRecord::Migration
  def self.up
    create_table :albums_songs, :id => false do |t|
         t.integer :album_id
         t.integer :song_id
     end
  end

  def self.down
    drop_table :albums_songs
  end
end

