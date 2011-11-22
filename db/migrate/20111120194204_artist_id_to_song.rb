class ArtistIdToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :s_a_id, :integer
  end

  def self.down
    remove_column :songs, :s_a_id
  end
end

