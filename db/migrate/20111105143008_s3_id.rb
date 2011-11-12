class S3Id < ActiveRecord::Migration
  def self.up
    add_column :songs, :s3_id, :string
  end

  def self.down
    remove_column :songs, :s3_id
  end
end
