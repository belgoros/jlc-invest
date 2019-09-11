class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.integer :client_id
      t.string :acc_number

      t.timestamps
    end
  end
end
