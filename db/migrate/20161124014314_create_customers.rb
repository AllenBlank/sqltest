class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.integer :account_number
      t.text :notes

      t.timestamps null: false
    end
  end
end
