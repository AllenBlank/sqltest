class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.integer :ship_to
      t.integer :run
      t.datetime :entry
      t.datetime :ship
      t.integer :weight
      t.integer :cubes
      t.integer :pieces
      t.integer :company
      t.integer :customer
      t.string :carrier
      t.boolean :danger

      t.timestamps null: false
    end
  end
end
