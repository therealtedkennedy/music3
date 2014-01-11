class SongImageToSongs < ActiveRecord::Migration
	def self.up
		add_column :songs, :image, :string

	end

	def self.down
		remove_column :songs, :image
	end
end

