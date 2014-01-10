class Super < ActiveRecord::Migration
  def self.up
    add_column :artists, :super_toggle, :boolean
  end

  def self.down
    remove_column :artists, :super_toggle
  end
end
