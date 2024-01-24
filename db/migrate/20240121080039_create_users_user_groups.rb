class CreateUsersUserGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :users_user_groups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :user_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
