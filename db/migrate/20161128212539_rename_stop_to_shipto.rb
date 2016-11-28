class RenameStopToShipto < ActiveRecord::Migration
  def change
    rename_table :stops, :shiptos
  end
end
