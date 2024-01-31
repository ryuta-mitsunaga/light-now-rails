class SessionsController < ApplicationController
  def new
    render json: { status: 200, message: 'ログインしてください。' }
  end
  
  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate_password(params[:password])
      session[:user_id] = user.id
      payload = { status: 200, message: 'ログインしました。', user: user }
    else
      payload = { status: 402,message: ['メールアドレスまたはパスワードが正しくありません。'] }
    end
    
    render json: payload
  end
  
  def destroy
    session[:user_id] = nil
    
    render json: { status: 200, message: 'ログアウトしました。' }
  end
end
