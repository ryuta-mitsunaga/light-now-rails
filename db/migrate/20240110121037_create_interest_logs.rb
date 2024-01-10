class CreateInterestLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :interest_logs do |t|
      t.integer :store_id
      t.integer :user_id
      t.date :interest_datetime
      t.integer :interest_count

      t.timestamps
    end
  end
end
