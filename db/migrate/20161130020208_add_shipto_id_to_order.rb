class AddShiptoIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shipto_id, :integer
  end
end
