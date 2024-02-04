class LineBotFriendController < ApplicationController
  def index
    # nameで前後一致LIKE検索
    line_bot_friends = LineBotFriend.where(line_bot_id: params[:line_bot_id]).where('name LIKE ?', "%#{params[:keyword]}%")
    render json: { status: { code: 200, message: 'success' }, line_bot_friends: line_bot_friends }
  end
end
