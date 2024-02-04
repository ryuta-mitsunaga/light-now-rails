class AddLineBotInfoToSendGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :send_groups, :line_bot_id, :integer, null: true
    add_column :send_groups, :created_user_id, :integer
  end
end
