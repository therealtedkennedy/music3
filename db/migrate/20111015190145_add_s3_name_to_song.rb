class AddS3NameToSong < ActiveRecord::Migration

  def self.up
    add_column :songs, :s3_name, :string
  end

  def self.down
    remove_column :songs, :s3_name
  end
end

