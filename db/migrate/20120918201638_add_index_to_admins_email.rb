class AddIndexToAdminsEmail < ActiveRecord::Migration[5.2]
  def change
    add_index :admins, :email, unique: true
  end
end
