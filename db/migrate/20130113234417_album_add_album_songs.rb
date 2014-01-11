class AlbumAddAlbumSongs < ActiveRecord::Migration
	def self.up
		add_column :albums, :album_songs, :string
	end

	def self.down
		remove_column :albums, :album_songs
	end
end
