class AddTypeDePlatToInscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :inscriptions, :type_de_plat, :string
  end
end
