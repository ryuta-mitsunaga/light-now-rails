class CreateLineBotFriendsSendGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :line_bot_friends_send_groups do |t|
      t.references :line_bot_friend, null: false, foreign_key: true
      t.references :send_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
