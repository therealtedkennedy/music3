class FixProfileLayout < ActiveRecord::Migration
 def self.up
    change_table :profile_layouts do |t|
      t.change :h2_font, :string
      t.change :h2_colour, :string
      t.change :h3_size, :string
      t.change :h3_font, :string
      t.change :h3_colour, :string
    end
  end

  def self.down
    change_table :profile_layouts do |t|

      t.change :h2_font, :text
      t.change :h2_colour, :text
      t.change :h3_size, :text
      t.change :h3_font, :date
      t.change :h3_colour, :date

    end
  end
end
