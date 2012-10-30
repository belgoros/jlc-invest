class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :client_id
      t.string :acc_number

      t.timestamps
    end
  end
end
