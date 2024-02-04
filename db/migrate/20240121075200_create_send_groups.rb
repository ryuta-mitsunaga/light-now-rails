class CreateSendGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :send_groups do |t|
      t.string :group_name

      t.timestamps
    end
  end
end
