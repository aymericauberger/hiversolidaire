class CreateInscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :inscriptions do |t|
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.string :plat

      t.timestamps
    end
  end
end
