class ApplicationController < ActionController::API
  # デバッグログに天狗をつける
  def debug(message = nul)
    logger.debug('👺👺👺👺👺👺👺👺');
    logger.debug(message);
    logger.debug('👺👺👺👺👺👺👺👺')
  end
  
  private

  # ユーザーがログインしているかチェックする
  def check_logged_in
    unless session[:user_id]
      return render json: { message: 'ログインしてください。' }, status: :forbidden
    end

    @user = User.find(session[:user_id])
  end
end
