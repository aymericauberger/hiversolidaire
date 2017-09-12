class AddVientAuDinerToInscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :inscriptions, :vient_au_diner, :boolean
  end
end
