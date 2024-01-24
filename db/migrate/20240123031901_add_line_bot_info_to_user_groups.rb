class AddLineBotInfoToUserGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :user_groups, :line_bot_id, :string, null: true
    add_column :user_groups, :created_user_id, :integer
  end
end
