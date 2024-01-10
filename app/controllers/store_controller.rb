require './app/services/hotpepper_api_service'

class StoreController < ApplicationController
  def index
    # ホットペッパーのAPIを叩く
    hotpepper_api_service = HotpepperApiService.new
    
    stores = hotpepper_api_service.get_store_info('', 0, false)
    
    render json: { status: 200, stores: stores }
  end
  
  def interest
    interest_log = InterestLog.where(user_id: params[:user_id]).first;
    
    if (interest_log.present?) 
      interest_log.increment('interest_count', 1)
      interest_log.save
    else
      # ログが存在しなければ作成
      InterestLog.create(
        user_id: params[:user_id],
        store_id: params[:store_id],
        interest_datetime: Time.now,
        interest_count: 1
      ) unless interest_log.present? 
    end
    
    render json: { status: 200, message: 'success' }
  end
end
