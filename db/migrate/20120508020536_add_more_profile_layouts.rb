class AddMoreProfileLayouts < ActiveRecord::Migration
 def self.up
    #paragraphs
    add_column :profile_layouts, :p_size, :string
    add_column :profile_layouts, :p_font, :string
    add_column :profile_layouts, :p_colour, :string

    #Div 1
    add_column :profile_layouts, :div_1_colour, :string
    add_column :profile_layouts, :div_1_transparency, :string
    add_column :profile_layouts, :div_1_border_colour, :string
    add_column :profile_layouts, :div_1_background_colour, :string
    add_column :profile_layouts, :div_1_border_width, :string

    #div 2
    add_column :profile_layouts, :div_2_colour, :string
    add_column :profile_layouts, :div_2_transparency, :string
    add_column :profile_layouts, :div_2_border_colour, :string
    add_column :profile_layouts, :div_2_background_colour, :string
    add_column :profile_layouts, :div_2_border_width, :string
  end

  def self.down
    remove_column :profile_layouts, :p_size
    remove_column :profile_layouts, :p_font
    remove_column :profile_layouts, :p_colour


    remove_column :profile_layouts, :div_1_colour
    remove_column :profile_layouts, :div_1_transparency
    remove_column :profile_layouts, :div_1_border_colour
    remove_column :profile_layouts, :div_1_background_colour
    remove_column :profile_layouts, :div_1_border_width

    remove_column :profile_layouts, :div_2_colour
    remove_column :profile_layouts, :div_2_transparency
    remove_column :profile_layouts, :div_2_border_colour
    remove_column :profile_layouts, :div_2_background_colour
    remove_column :profile_layouts, :div_2_border_width

  end
end
