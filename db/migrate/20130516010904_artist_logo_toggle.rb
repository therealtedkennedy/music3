class ArtistLogoToggle < ActiveRecord::Migration
	def self.up
		add_column :artists, :logo_toggle, :boolean
	end

	def self.down
		remove_column :artists, :logo_toggle
	end
end
