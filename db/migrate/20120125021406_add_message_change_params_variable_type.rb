class AddMessageChangeParamsVariableType < ActiveRecord::Migration
  def self.up
    change_table :transactions do |t|
      t.change :params, :text
    end

    add_column :transactions, :message, :string

  end

  def self.down
    change_table :transactions do |t|
      t.change :params, :text
    end

    remove_column :transactions, :message
  end


end
