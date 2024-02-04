class SendGroupController < ApplicationController
  before_action :check_logged_in
  
  def index
    send_groups = SendGroup.where(created_user_id: @user.id)
    
    send_group_with_users = send_groups.map do |ud|
      # users = UsersSendGroup.includes(:user).where(send_group: ud).map {|uug| {
      #   id: uug.user.id,
      #   name: uug.user.name,
      # }}

      line_bot_friends = LineBotFriendsSendGroup.includes(:line_bot_friend).where(send_group: ud).map {|uug| {
        id: uug.line_bot_friend.id,
        name: uug.line_bot_friend.name,
        line_user_id: uug.line_bot_friend.line_user_id,
      }}

      {
        id: ud.id,
        group_name: ud.group_name,
        line_bot_friends: line_bot_friends,
        created_user_id: ud.created_user_id,
        line_bot_id: ud.line_bot_id
      }
    end
    
    render json: { status: { code: 200, message: 'success' }, send_groups: send_group_with_users }
  end
  
  def create
    send_group = SendGroup.create(
      line_bot_id: params[:lineBotId],
      group_name: params[:groupName],
      created_user_id: @user.id
    )
    
    render json: { status: { code: 200, message: 'success' }, send_group: send_group }
  end
  
  def addLineBotFriend 
    send_group = SendGroup.find(params[:send_group_id])
    lineBotFriend = LineBotFriend.find(params[:lineBotFriendId])
    
    LineBotFriendsSendGroup.create(line_bot_friend: lineBotFriend, send_group: send_group)
    
    render json: { status: { code: 200, message: 'success' }, send_group: send_group }
  end
  
  def deleteSendGroup
    send_group = SendGroup.find(params[:send_group_id])
    send_group.destroy
    
    render json: { status: { code: 200, message: 'success' } }
  end
  
  def deleteUser
    send_group = SendGroup.find(params[:send_group_id])
    debug(params[:line_bot_friend_id])
    line_bot_friend = LineBotFriend.find(params[:line_bot_friend_id])
    
    line_bot_friend_send_groups = LineBotFriendsSendGroup.find_by(line_bot_friend: line_bot_friend, send_group: send_group)
    
    line_bot_friend_send_groups.destroy
    
    render json: { status: { code: 200, message: 'success' } }
  end
end
