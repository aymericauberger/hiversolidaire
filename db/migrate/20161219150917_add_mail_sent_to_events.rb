class AddMailSentToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :mail_sent, :boolean
  end
end
