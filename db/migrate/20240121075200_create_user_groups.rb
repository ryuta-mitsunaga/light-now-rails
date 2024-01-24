class CreateUserGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :user_groups do |t|
      t.string :group_name

      t.timestamps
    end
  end
end
