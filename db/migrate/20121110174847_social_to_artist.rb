class SocialToArtist < ActiveRecord::Migration
	def self.up
		add_column :artists,:social_title, :string
		add_column :artists,:fb_page_url, :string
	end

	def self.down
		remove_column :artists, :social_title
		remove_column :artists, :fb_page_url
	end
end
