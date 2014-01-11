class TwitterNameAddToArtist < ActiveRecord::Migration
	def self.up
		add_column :artists,:twitter_name, :string
	end

	def self.down
		remove_column :artists, :twitter_name
	end
end
