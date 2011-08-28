class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :name
      t.string :city
      t.string :province
      t.string :country
      t.text :influence
      t.text :bio
      t.text :contact_info
      t.date :date_founded
      t.date :created_date

      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end
