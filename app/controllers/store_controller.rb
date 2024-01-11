require './app/services/hotpepper_api_service'

class StoreController < ApplicationController
  def index
    # ホットペッパーのAPIを叩く
    hotpepper_api_service = HotpepperApiService.new
    
    current_page = params[:page].to_i
    
    stores = hotpepper_api_service.get_store_info(params[:keyword], current_page, false)
    
    interest_logs = InterestLog.where('user_id', params[:user_id])
    
    newStores = stores[:columns].map{ |store|
      interest_log = interest_logs.find{ |interest_log| interest_log.store_id === store[:id] }
      store['interest_count'] = interest_log ? interest_log.interest_count : 0
      
      store
    }
    
    total_count = stores[:results_available].to_i
    
    paginate = {
      total_count: total_count,
      total_page: (total_count / 10).ceil,
      current_page: current_page
    }
    
    render json: { status: {code: 200, message: 'succdess'}, stores: newStores, paginate: paginate }
  end
  
  def interest
    interest_log = InterestLog.where('user_id': params[:user_id], 'store_id': params[:store_id]).first;
    
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
      )
    end
    
    render json: { status: 200, message: 'success' }
  end
end
