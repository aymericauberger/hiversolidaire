class AddIndexToPhoneUser < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :phone
  end
end
