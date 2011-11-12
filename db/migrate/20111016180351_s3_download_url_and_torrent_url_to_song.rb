class S3DownloadUrlAndTorrentUrlToSong < ActiveRecord::Migration
 def self.up
    add_column :songs, :download_link, :string
    add_column :songs, :torrent_link, :string
  end

  def self.down
    remove_column :songs, :download_link
    remove_column :songs, :torrent_link
  end
end
