class CreateAlbumCodes < ActiveRecord::Migration
  def self.up
    create_table :album_codes do |t|
      t.string :album_code
      t.integer :code_album_id

      t.timestamps
    end
  end

  def self.down
    drop_table :album_codes
  end
end
