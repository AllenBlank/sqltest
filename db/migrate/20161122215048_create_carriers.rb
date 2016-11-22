class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.datetime :date
      t.integer :cubes
      t.integer :weight
      t.integer :value
      t.text :orders
      t.integer :order_count

      t.timestamps null: false
    end
  end
end
