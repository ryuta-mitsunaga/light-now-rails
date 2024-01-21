class CreateLineAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :line_accounts do |t|
      t.string :line_user_id
      t.string :name
      t.string :picture_url
      t.string :line_bot_id

      t.timestamps
    end
    add_index :line_accounts, [:line_bot_id, :line_user_id], unique: true
  end
end
