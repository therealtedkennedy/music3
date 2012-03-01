class RenameUsersArtistsToArtistUsers < ActiveRecord::Migration
  def self.up
    rename_table :users_artists, :artists_users
  end

  def self.down
    rename_table :artists_users, :users_artists
  end
end
