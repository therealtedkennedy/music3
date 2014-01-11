class AlbumSocialOn < ActiveRecord::Migration
	def self.up
		add_column :albums, :social_on, :boolean
	end

	def self.down
		remove_column :albums, :social_on
	end
end
