class CreateVolunteers < ActiveRecord::Migration[5.0]
  def change
    create_table :volunteers do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :accept_save
      t.string :ip_address

      t.timestamps
    end
  end
end
