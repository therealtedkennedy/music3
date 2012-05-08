class ProfileLayout < ActiveRecord::Migration
   def self.up
    create_table :profile_layouts do |t|
      t.string :h1_size
      t.string :h1_font
      t.string :h1_colour
      t.string :h2_size
      t.text :h2_font
      t.text :h2_colour
      t.text :h3_size
      t.date :h3_font
      t.date :h3_colour

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_layouts
  end
end

