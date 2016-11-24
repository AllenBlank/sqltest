class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.integer :number
      t.integer :customer_id
      t.text :notes

      t.timestamps null: false
    end
  end
end
