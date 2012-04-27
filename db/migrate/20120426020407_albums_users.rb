class AlbumsUsers < ActiveRecord::Migration

  def self.up
    create_table :albums_users, :id => false do |t|
         t.integer :album_id
         t.integer :user_id
     end
  end

  def self.down
    drop_table :albums_users
  end
end
