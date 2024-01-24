class CreateLineBots < ActiveRecord::Migration[7.1]
  def change
    create_table :line_bots do |t|
      t.integer :user_id
      t.string :line_bot_id
      t.string :name
      t.string :picture_url
      t.string :line_channel_secret
      t.string :line_channel_token
      t.string :basic_id

      t.timestamps
    end
  end
end
