class AddingTwitterInfoToUsers < ActiveRecord::Migration
	def self.up
		add_column :users, :twitter_uid, :string
		add_column :users, :twitter_nickname, :string
		add_column :users, :twitter_name, :string

	end

	def self.down
		remove_column :users, :twitter_uid
		remove_column :users, :twitter_nickname
		remove_column :users, :twitter_name
	end
end


