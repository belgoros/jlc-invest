class AddCloseDateToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :close_date, :date
  end
end
