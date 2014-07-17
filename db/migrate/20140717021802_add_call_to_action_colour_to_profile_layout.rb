class AddCallToActionColourToProfileLayout < ActiveRecord::Migration
  def self.up
    add_column :profile_layouts, :call_to_action_colour, :string
  end

  def self.down
    remove_column :profile_layouts, :call_to_action_colour

  end
end
