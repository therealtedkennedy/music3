class ChangeNavHoverStateToNavHoverColour < ActiveRecord::Migration
  def self.up
    rename_column :profile_layouts, :nav_hover_state, :nav_hover_colour
  end

  def self.down

  end
end
