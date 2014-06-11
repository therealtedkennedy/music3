class AddingProfileElliments < ActiveRecord::Migration
  def self.up
    add_column :profile_layouts, :logo_toggle, :boolean
    add_column :profile_layouts, :logo_size, :integer, :default => 36
    add_column :profile_layouts, :log_color, :string
    add_column :profile_layouts, :background_color, :string
    add_column :profile_layouts, :background_toggle, :boolean
  end

  def self.down
    remove_column :profile_layouts, :logo_toggle
    remove_column :profile_layouts, :logo_size
    remove_column :profile_layouts, :log_color
    remove_column :profile_layouts, :background_color
    remove_column :profile_layouts, :background_toggle
  end
end

