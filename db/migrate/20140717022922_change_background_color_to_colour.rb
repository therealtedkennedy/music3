class ChangeBackgroundColorToColour < ActiveRecord::Migration
  def self.up
    rename_column :profile_layouts, :background_color, :background_colour
  end

  def self.down

  end
end
