class AddRememberTokenIndexToAdmins < ActiveRecord::Migration
  def change
    add_index  :admins, :remember_token
  end
end
