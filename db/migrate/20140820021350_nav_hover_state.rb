class NavHoverState < ActiveRecord::Migration
  def self.up

    add_column :profile_layouts, :nav_hover_state, :string

  end

  def self.down

    remove_column :profile_layouts, :nav_hover_state

  end
end
