class LogoToArtist < ActiveRecord::Migration
	def self.up
		add_column :artists, :logo, :string

	end

	def self.down
		remove_column :artists, :logo
	end
end
