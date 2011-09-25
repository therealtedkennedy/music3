class ChangeUrlSlugToSongUrlSlugInSongs2 < ActiveRecord::Migration
  def change
    rename_column :songs, :url_slug, :song_url_slug
  end
end
