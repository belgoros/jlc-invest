class AddRememberTokenIndexToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_index  :admins, :remember_token
  end
end
