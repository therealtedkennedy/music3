class AddArtistIdToProfileLayout < ActiveRecord::Migration
   def self.up
    add_column :profile_layouts, :artist_id, :integer

   end

  def self.down
    remove_column :profile_layouts, :artist_id
  end
end

