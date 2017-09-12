class AddResponsableToInscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :inscriptions, :responsable, :boolean
  end
end
