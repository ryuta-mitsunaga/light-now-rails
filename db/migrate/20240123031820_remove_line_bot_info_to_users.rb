class RemoveLineBotInfoToUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :line_channel_secret, :string
    remove_column :users, :line_channel_token, :string
  end
end
