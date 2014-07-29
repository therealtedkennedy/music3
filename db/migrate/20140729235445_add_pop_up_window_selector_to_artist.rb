class AddPopUpWindowSelectorToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :quick_start_popup_toggle, :boolean
  end

  def self.down
    remove_column :artists, :quick_start_popup_toggle
  end
end
