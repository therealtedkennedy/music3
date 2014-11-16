class AddNavColour < ActiveRecord::Migration
  def self.up

     add_column :profile_layouts, :nav_text_colour, :string


  end

  def self.down

    remove_column :profile_layouts, :nav_text_colour

  end
end
