class S3MetaName < ActiveRecord::Migration
	def self.up
		add_column :songs, :s3_meta_tag, :string
	end

	def self.down
		remove_column :songs, :s3_meta_tag
	end
end
