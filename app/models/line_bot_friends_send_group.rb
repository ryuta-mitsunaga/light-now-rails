class LineBotFriendsSendGroup < ApplicationRecord
  belongs_to :line_bot_friend
  belongs_to :send_group
end
