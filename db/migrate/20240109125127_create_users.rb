class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: true
      t.string :password_digest
      t.string :name
      t.string :line_channel_secret
      t.string :line_channel_token

      t.timestamps
    end
  end
end
