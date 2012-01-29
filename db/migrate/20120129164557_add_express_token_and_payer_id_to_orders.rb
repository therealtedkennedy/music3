class AddExpressTokenAndPayerIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :express_token, :string
    add_column :orders, :express_payer_id, :string
  end

  def self.down
    remove_column :orders, :express_token
    remove_column :orders, :express_payer_id
  end
end
