class CreateAlbums < ActiveRecord::Migration

    def self.up
      create_table :albums do |t|
        t.string :al_name
        t.string :al_type
        t.string :pri_artist
        t.string :contrib_artist
        t.string :al_copy_write
        t.date :al_rel_date
        t.string :pay_type
        t.integer :al_amount
        t.string :producer
        t.string :al_producer
        t.string :al_label
        t.text :liner_notes
        t.integer :downloads
        t.integer :plays
        t.integer :shares


        t.timestamps
      end
    end

    def self.down
      drop_table :albums
    end
end