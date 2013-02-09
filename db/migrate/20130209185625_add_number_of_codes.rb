class AddNumberOfCodes < ActiveRecord::Migration

	def self.up
		add_column :artists, :number_of_codes, :integer, :default => '0'
	end

	def self.down
		remove_column :artists, :number_of_codes
	end
end

