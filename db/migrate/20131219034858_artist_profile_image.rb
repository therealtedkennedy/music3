class ArtistProfileImage < ActiveRecord::Migration
  def self.up
    add_column :artists, :profile_image, :string

  end

  def self.down
    remove_column :artists, :profile_image
  end
end
