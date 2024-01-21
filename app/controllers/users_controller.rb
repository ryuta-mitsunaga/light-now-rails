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
      line_channel_secret: params[:lineChannelSecret],
      line_channel_token: params[:lineChannelToken]
    )
    
    render json: {status: !!user ? 200 : 404, user: user,  }
  end
  
  def logout
    session[:user_id] = nil
    
    render json: { status: 200, message: 'ログアウトしました。' }
  end 
end
