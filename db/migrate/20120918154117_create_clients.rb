class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :street
      t.string :house
      t.string :box
      t.string :zipcode
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
