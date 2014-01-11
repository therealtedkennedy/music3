class SongSocialPromoTurnOnOff < ActiveRecord::Migration
	def self.up
		add_column :songs, :social_on, :boolean
	end

	def self.down
		remove_column :songs, :social_on
	end
end
