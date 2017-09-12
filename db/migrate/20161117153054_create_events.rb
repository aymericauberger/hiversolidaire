class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :type
      t.date :start_date

      t.timestamps
    end
  end
end
