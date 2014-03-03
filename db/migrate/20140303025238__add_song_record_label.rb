class AddSongRecordLabel < ActiveRecord::Migration
  def self.up
    add_column :songs, :label, :string
  end

  def self.down
    remove_column :songs, :label
  end
end
