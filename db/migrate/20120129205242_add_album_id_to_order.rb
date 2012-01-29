class AddAlbumIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :album_id, :integer
   end

  def self.down
    remove_column :orders, :album_id

  end
end

