class AddSongProducer < ActiveRecord::Migration
  def self.up
    add_column :songs, :producer, :string
  end

  def self.down
    remove_column :producer
  end

end
