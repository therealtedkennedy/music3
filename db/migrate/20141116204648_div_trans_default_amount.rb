class DivTransDefaultAmount < ActiveRecord::Migration
  def self.up
    change_column :profile_layouts, :div_1_transparency, :string, :default => 50
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
