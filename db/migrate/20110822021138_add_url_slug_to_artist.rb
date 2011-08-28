class AddUrlSlugToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :url_slug, :string
  end

  def self.down
    remove_column :artists, :url_slug
  end
end
