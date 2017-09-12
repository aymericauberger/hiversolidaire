class CreateCommentaires < ActiveRecord::Migration[5.0]
  def change
    create_table :commentaires do |t|
      t.date :date
      t.text :text

      t.timestamps
    end
  end
end
