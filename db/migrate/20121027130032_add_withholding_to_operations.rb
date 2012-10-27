class AddWithholdingToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :withholding, :decimal, precision: 5, scale: 2
  end
end
