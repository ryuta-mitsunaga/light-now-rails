class CreateLineBotFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :line_bot_friends do |t|
      t.string :line_user_id
      t.integer :line_bot_id
      t.string :name
      t.string :picture_url

      t.timestamps
    end
  end
end
