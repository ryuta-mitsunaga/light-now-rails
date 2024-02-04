class SendGroup < ApplicationRecord
  has_many :line_bot_friend_send_groups, dependent: :destroy
  has_many :users, through: :line_bot_friend_send_groups
end
