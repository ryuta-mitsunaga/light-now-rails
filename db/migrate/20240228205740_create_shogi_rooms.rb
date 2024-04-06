class CreateShogiRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :shogi_rooms do |t|
      t.integer :user_id
      t.string :name
      t.timestamps
    end
  end
end
