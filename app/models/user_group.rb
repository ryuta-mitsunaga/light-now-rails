class UserGroup < ApplicationRecord
  has_many :users_user_groups, dependent: :destroy
  has_many :users, through: :users_user_groups
end
