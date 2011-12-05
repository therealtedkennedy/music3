class ArtistIdAndSongIdToAlbum < ActiveRecord::Migration
  def self.up
    add_column :albums, :al_a_id, :integer
    add_column :albums, :al_s_id, :integer
  end

  def self.down
    remove_column :albums, :al_a_id
    remove_column :albums, :al_s_id
  end
end
