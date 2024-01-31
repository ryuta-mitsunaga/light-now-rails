require './app/services/hotpepper_api_service'

class StoreController < ApplicationController
  before_action :check_logged_in
  
  def index
    return_stores = []
    paginate = {
      total_count: 0,
      total_page: 0,
      current_page: params[:page].to_i
    }
    
    is_interest_only = ActiveRecord::Type::Boolean.new.cast(params[:interested])

    if is_interest_only then
      # 気になる店舗のみ取得
      interest_logs = InterestLog.where('user_id', @user.id)
      
      store_ids = interest_logs.map{ |interest_log| interest_log.store_id }
      
      paginate[:total_count] = store_ids.count
      paginate[:total_page] = (paginate[:total_count] / 10).ceil
      
      if paginate[:total_count] === 0 then
        return render json: { status: {code: 200, message: 'succdess'}, stores: [], paginate: paginate }
      elsif paginate[:total_count] > 20 then
        # 20件ずつに分割して取得
        store_ids.each_slice(20) do |store_ids|
          stores.concat(HotpepperApiService.new.get_store_info(nil, 0, false, store_ids.join(','))[:columns])
        end
      else
        return_stores = HotpepperApiService.new.get_store_info(nil, 0, false, store_ids.join(','))[:columns]
      end
      
      return_stores.each_with_index{ |store, i|
        interest_log = interest_logs.find{ |interest_log| interest_log.store_id === store[:id] }
        store[:interest_count] = interest_log.interest_count
      }
    else
      # ホットペッパーのAPIを叩く
      hotpepper_api_service = HotpepperApiService.new
      
      interested = ActiveRecord::Type::Boolean.new.cast(params[:interested]) 
      
      stores = hotpepper_api_service.get_store_info(params[:keyword], paginate[:current_page], false)
      
      interest_logs = InterestLog.where('user_id', @user.id)
      
      return_stores = stores[:columns].map{ |store|
        interest_log = interest_logs.find{ |interest_log| interest_log.store_id === store[:id] }

        store['interest_count'] = interest_log ? interest_log.interest_count : 0
        
        store
      }
      
      paginate[:total_count] = stores[:results_available].to_i
      paginate[:total_page] = (paginate[:total_count] / 10).ceil
      paginate[:current_page] = params[:page].to_i
    end
    
    render json: { status: {code: 200, message: 'success'}, stores: return_stores, paginate: paginate }
  end
  
  def interest
    interest_log = InterestLog.where('user_id': @user.id, 'store_id': params[:store_id]).first;
    
    if (interest_log.present?) 
      interest_log.increment('interest_count', 1)
      interest_log.save
    else
      # ログが存在しなければ作成
      InterestLog.create(
        user_id: @user.id,
        store_id: params[:store_id],
        interest_datetime: Time.now,
        interest_count: 1
      )
    end
    
    render json: { status: 200, message: 'success' }
  end
  
  def clearInterest
    InterestLog.where('user_id': @user.id, 'store_id': params[:store_id]).first.destroy
    
    render json: { status: 200, message: 'success' }
  end
end
