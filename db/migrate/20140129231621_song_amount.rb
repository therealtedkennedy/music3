class SongAmount < ActiveRecord::Migration

  def self.up
    add_column :songs, :amount, :integer, :default => 0

  end

  def self.down
    remove_column :songs, :amount
  end
end
