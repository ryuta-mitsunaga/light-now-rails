class CreateShogiLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :shogi_logs do |t|
      t.integer :shogi_room_id
      t.integer :user_id
      t.text :sfen
      t.timestamps
    end
  end
end
