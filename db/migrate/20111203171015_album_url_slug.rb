class AlbumUrlSlug < ActiveRecord::Migration
  def self.up
    add_column :albums, :album_url_slug, :string
  end

  def self.down
    remove_column :albums, :album_url_slug
  end
end
