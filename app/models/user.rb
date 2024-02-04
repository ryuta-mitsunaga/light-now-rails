class User < ApplicationRecord
  has_secure_password
  
  has_many :line_bot_friend_send_groups
  has_many :send_groups, through: :line_bot_friend_send_groups
end
