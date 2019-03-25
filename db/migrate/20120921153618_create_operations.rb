class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations do |t|
      t.integer :account_id
      t.string :operation_type
      t.date :value_date
      t.date :close_date
      t.decimal :sum, precision: 10, scale: 2
      t.decimal :rate, precision: 5, scale: 2
      t.decimal :withholding, precision: 5, scale: 2
      t.integer :duration
      t.decimal :interests, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
