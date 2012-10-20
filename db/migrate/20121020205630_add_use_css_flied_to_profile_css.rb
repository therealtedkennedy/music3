class AddUseCssFliedToProfileCss < ActiveRecord::Migration
	def self.up
		add_column :profile_layouts, :use_css, :boolean, :default => false
	end

	def self.down
		remove_column :profile_layouts, :use_css
	end
end
