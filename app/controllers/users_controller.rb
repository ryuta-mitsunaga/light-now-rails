class UsersController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate_password(params[:password])
      session[:user_id] = user.id
      payload = { status: 200, message: 'ログインしました。', user: user }
    else
      payload = { status: 402,message: ['メールアドレスまたはパスワードが正しくありません。'] }
    end
    
    render json: payload
  end
  
  def signup
    user = User.create(
      email: params[:email], 
      password: (params[:password]), 
      name: params[:name],
      line_user_id: params[:line_user_id]
    )
    
    render json: {status: !!user ? 200 : 404, user: user,  }
  end
  
  def logout
    session[:user_id] = nil
    
    render json: { status: 200, message: 'ログアウトしました。' }
  end 
  
  def searchUser
    check_logged_in()
    
    user = User.where(email: params[:email]).first
    
    render json: { status: {code: 200, message: 'success'}, user: user}
  end
  
  def update
    user = User.find(params[:id])
    
    user.update(
      email: params[:email],
      password: params[:password],
      name: params[:name],
      line_user_id: params[:lineUserId]
    )
    
    render json: { status: {code: 200, message: 'success'}, user: user}
  end
  
  def isRegistered
    user = User.where(line_user_id: params[:line_user_id]).first
    
    render json: { status: {code: 200, message: 'success'}, result: !!user.email}
  end
  
  def getUser
    check_logged_in()
    
    # ログインしていない場合はリターン
    unless @user then
      return
    end

    render json: { status: {code: 200, message: 'success'}, user: @user}
  end
end
