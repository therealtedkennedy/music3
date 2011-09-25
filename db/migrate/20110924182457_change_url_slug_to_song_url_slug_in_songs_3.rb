class ChangeUrlSlugToSongUrlSlugInSongs3 < ActiveRecord::Migration
  def self.up
    rename_column :songs, :url_slug, :song_url_slug
  end

  def self.down
    rename_column :songs, :url_slug, :song_url_slug
  end
end

