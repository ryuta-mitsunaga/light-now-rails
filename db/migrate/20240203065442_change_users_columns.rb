class ChangeUsersColumns < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :line_bot_friend_id, :string
    remove_column :users, :line_bot_id, :string
  end
end
