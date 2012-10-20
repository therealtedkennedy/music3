class AddProfileCssToProfileEdit < ActiveRecord::Migration
	def self.up
		add_column :profile_layouts, :profile_css, :text
	end

	def self.down
		remove_column :profile_layouts, :profile_css
	end
end
