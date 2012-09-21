class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.integer :client_id
      t.string :type
      t.date :value_date
      t.date :close_date
      t.decimal :sum
      t.decimal :rate
      t.integer :duration
      t.decimal :interests
      t.decimal :total

      t.timestamps
    end
  end
end
