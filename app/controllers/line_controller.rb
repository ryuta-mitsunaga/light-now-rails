require './app/services/hotpepper_api_service'

class LineController < ApplicationController
  def client(line_channel_secret, line_channel_token)
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = line_channel_secret
      config.channel_token = line_channel_token
    }
  end
  
  def sendMessage
    user = User.find(params[:user_id])
    store_id = params[:store_id]
    line_account = LineAccount.find(params[:line_account_id])
    
    hotpepper_api_service = HotpepperApiService.new
    
    carousel_columns = hotpepper_api_service.get_store_info('', 0, true, store_id, user.name)
    
    message =  {
      "type": "template",
      "altText": "⭐️#{user.name}さんが気になっています⭐️",
      "template": {
        "type": "carousel",
        "columns": carousel_columns[:columns],
        "imageAspectRatio": "rectangle",
        "imageSize": "cover"
      }
    }
    
    client(user.line_channel_secret, user.line_channel_token).push_message(line_account.line_user_id, message)
    
    # ユーザーのメッセージを返す
    render json: { status: 200, message: message }
  end
  
  def webhook
    if (params['events'][0]['type'] === 'follow') then 
      line_user_id = params['events'][0]['source']['userId']
      user = User.find(1)
      
      profile = JSON.parse(client(user.line_channel_secret, user.line_channel_token).get_profile(line_user_id).body)
      
      LineAccount.create(
        line_user_id: 'Uadc78561952e9dad2fa160b900b7ca78', 
        name: profile['displayName'], 
        picture_url: profile['pictureUrl'],
        line_bot_id: 'U3a2108667cef0a7a263959ebe2db809b'
      )
      
      # LineAccount.create(
      #   line_user_id: line_user_id, 
      #   name: profile['displayName'], 
      #   picture_url: profile['pictureUrl'],
      #   line_bot_id: params['destination']
      # )
    end
    
    render json: { status: 200, message: 'success' }
  end
  
  def indexAccount
    user = User.find(params[:user_id])
    line_bot_id = JSON.parse(client(user.line_channel_secret, user.line_channel_token).get_bot_info.body)['userId']
    
    line_accounts = LineAccount.where(line_bot_id: line_bot_id)
    
    response = line_accounts.map{ |line_account| {
      id: line_account.id,
      name: line_account.name,
      picture_url: line_account.picture_url,
    }}
    
    render json: { status: {code: 200, message: 'success'}, line_accounts: response }
  end
end
