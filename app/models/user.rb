class User < ApplicationRecord
  has_secure_password
  
  has_many :users_user_groups
  has_many :user_groups, through: :users_user_groups
end
