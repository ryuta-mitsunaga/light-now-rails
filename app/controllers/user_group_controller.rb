class UserGroupController < ApplicationController
  def index
    user_groups = UserGroup.where(created_user_id: params[:user_id])
    
    user_group_with_users = user_groups.map do |ud|
      users = UsersUserGroup.includes(:user).where(user_group: ud).map {|uug| {
        id: uug.user.id,
        name: uug.user.name,
      }}

      {
        id: ud.id,
        group_name: ud.group_name,
        users: users,
        created_user_id: ud.created_user_id,
      }
    end
    
    render json: { status: { code: 200, message: 'success' }, user_groups: user_group_with_users }
  end
  
  def create
    user_group = UserGroup.create(
      line_bot_id: params[:lineBotId],
      group_name: params[:groupName],
      created_user_id: params[:user_id]
    )
    
    render json: { status: { code: 200, message: 'success' }, user_group: user_group }
  end
  
  def addUser 
    user_group = UserGroup.find(params[:user_group_id])
    user = User.find(params[:userId])
    
    UsersUserGroup.create(user: user, user_group: user_group)
    
    render json: { status: { code: 200, message: 'success' }, user_group: user_group }
  end
  
  def deleteUserGroup
    user_group = UserGroup.find(params[:user_group_id])
    user_group.destroy
    
    render json: { status: { code: 200, message: 'success' } }
  end
  
  def deleteUser
    user_group = UserGroup.find(params[:user_group_id])
    user = User.find(params[:user_id])
    
    users_user_group = UsersUserGroup.find_by(user: user, user_group: user_group)
    users_user_group.destroy
    
    render json: { status: { code: 200, message: 'success' } }
  end
end
