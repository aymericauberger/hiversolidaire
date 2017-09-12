class ChangeInscriptionsTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :inscriptions, :user_id
    add_column :inscriptions, :volunteer_id, :integer
    add_foreign_key :inscriptions, :volunteers
  end
end
