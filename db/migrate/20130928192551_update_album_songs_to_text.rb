class UpdateAlbumSongsToText < ActiveRecord::Migration

	def self.up
		change_column :albums, :album_songs, :text
	end

	def self.down
		change_column :albums, :album_songs, :string
	end

end
