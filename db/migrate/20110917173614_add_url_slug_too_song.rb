class AddUrlSlugTooSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :song_url_slug, :string
  end

  def self.down
    remove_column :songs, :song_url_slug
  end
end

