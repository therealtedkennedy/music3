class ChangeLogColorToColour < ActiveRecord::Migration
  def self.up
    rename_column :profile_layouts, :log_color, :logo_colour
  end

  def self.down

  end
end
