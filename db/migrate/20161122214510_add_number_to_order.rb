class AddNumberToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :number, :string
  end
end
