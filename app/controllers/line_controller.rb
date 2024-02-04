require './app/services/hotpepper_api_service'

class LineController < ApplicationController
  def client(line_channel_secret, line_channel_token)
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = line_channel_secret
      config.channel_token = line_channel_token
    }
  end
  
  def sendMessage
    check_logged_in()
    
    user = User.find(@user.id)
    store_id = params[:store_id]
    send_group = SendGroup.find(params[:send_group_id])
    
    line_bot_friends =  LineBotFriendsSendGroup.includes(:line_bot_friend).where(send_group: send_group).map {|uug| {
      id: uug.line_bot_friend.id,
      name: uug.line_bot_friend.name,
      line_user_id: uug.line_bot_friend.line_user_id,
    }}
    
    # send_groupに紐づくLINEボットが登録されていない場合はエラーを返す
    unless send_group.line_bot_id then
      render json: { status: {code: 404, message: 'ユーザーグループにLINEボットが登録されていません。'}}
      return
    end
    
    line_bot = LineBot.find(send_group.line_bot_id)

    hotpepper_api_service = HotpepperApiService.new
    
    carousel_columns = hotpepper_api_service.get_store_info('', 0, true, store_id, user.name)
    log = [];
    
    line_bot_friends.each { |line_bot_friend|
      message = {
        "type": "template",
        "altText": "⭐️#{user[:name]}さんが気になっています⭐️",
        "template": {
          "type": "carousel",
          "columns": carousel_columns[:columns],
          "imageAspectRatio": "rectangle",
          "imageSize": "cover"
        }
      }

      log << client(line_bot[:line_channel_secret], line_bot[:line_channel_token]).push_message(line_bot_friend[:line_user_id], message)
    }

    render json: { status: {code: 200, message: log}}
  end

  def indexAccount
    check_logged_in()
    
    user = User.find(@user.id)
    line_bot_id = JSON.parse(client(user.line_channel_secret, user.line_channel_token).get_bot_info.body)['userId']
    
    line_accounts = LineAccount.where(line_bot_id: line_bot_id)
    
    response = line_accounts.map{ |line_account| {
      id: line_account.id,
      name: line_account.name,
      picture_url: line_account.picture_url,
      basic_id: line_account.basic_id,
    }}
    
    render json: { status: {code: 200, message: 'success'}, line_accounts: response }
  end
  
  def createLineBot
    check_logged_in()
    
    line_bot_info = JSON.parse(client(params[:lineChannelSecret], params[:lineChannelToken]).get_bot_info.body)
    
    line_bot = LineBot.create(
      user_id: @user.id,
      line_bot_id: line_bot_info['userId'],
      name: line_bot_info['displayName'],
      picture_url: line_bot_info['pictureUrl'],
      line_channel_secret: params[:lineChannelSecret],
      line_channel_token: params[:lineChannelToken],
      basic_id: line_bot_info['basicId']
    )
    
    render json: { status: {code: 200, message: 'success'}, line_bot: line_bot }
  end
  
  def indexLineBot
    check_logged_in()
    
    line_bots = LineBot.where(user_id: @user.id).map{ |line_bot| {
      id: line_bot.id,
      name: line_bot.name,
      picture_url: line_bot.picture_url,
      basic_id: line_bot.basic_id,
    }}
    
    render json: { status: {code: 200, message: 'success'}, line_bots: line_bots }
  end
  
  def reacquisitionLineBot
    check_logged_in()
    
    line_bot = LineBot.find(params[:line_bot_id])
    
    line_bot_info = JSON.parse(client(line_bot.line_channel_secret, line_bot.line_channel_token).get_bot_info.body)
    
    line_bot.update(
      name: line_bot_info['displayName'],
      picture_url: line_bot_info['pictureUrl'],
      basic_id: line_bot_info['basicId']
    )
    
    render json: { status: {code: 200, message: 'success'}, line_bot: line_bot }
  end
  
  def linkageLineAccount
    user = User.find(@user.id)
    
    debug(ENV['OFFICIA_LINE_CHANNEL_SECRET'])
    debug(ENV['OFFICIA_LINE_CHANNEL_TOKEN'])
    
    # .envのLINE_USER_ID_FOR_OFFICIAL_DEVを使う
    link_token = client(ENV['OFFICIA_LINE_CHANNEL_SECRET'], ENV['OFFICIA_LINE_CHANNEL_TOKEN']).create_link_token(ENV['OFFICIAL_LINE_USER_ID'])
    debug(link_token)
    
    # line_account = LineAccount.find(params[:line_account_id])
    
    # client(user.line_channel_secret, user.line_channel_token).link_rich_menu_to_user(line_account.line_user_id, params[:rich_menu_id])
    
    # render json: { status: {code: 200, message: 'success'}, line_account: line_account }
  end
  
  
  def webhookSignup
    if (params['events'][0]['type'] === 'follow') then
      line_user_id = params['events'][0]['source']['userId']
      
      user = User.where(line_user_id: line_user_id).first
      
      # 既に登録済みの場合は409を返す
      if user then
        render json: { status: 409, message: '既に登録済みです。' }
        debug('既に登録済みです。')
        return
      end
      
      client(ENV['OFFICIA_LINE_CHANNEL_SECRET'], ENV['OFFICIA_LINE_CHANNEL_TOKEN'])
      
      profile = JSON.parse(@client.get_profile(line_user_id).body)
      
      user = User.create(
        password: 'test',
        name: profile['displayName'],
        line_user_id: line_user_id
      )
      
      debug(user)
      
      message =  {
        "type": "template",
        "altText": "Account Link",
        "template": {
          "type": "buttons",
          "text": "ライなうユーザー登録",
          "actions": [
            {
              "type": "uri",
              "label": "登録する",
              "uri": "#{ENV['FRONT_BASE_URL']}/user/#{user.id}/lineLink?lineUserId=#{line_user_id}"
            }
          ],
        }
      }
      
      @client.push_message(line_user_id, message)
    end
    
    render json: { status: 200, message: 'success' }
  end
  
  def addLineBotFriend
    if (params['events'][0]['type'] == 'follow') then
    
      line_bot = LineBot.find_by(line_bot_id: params['destination'])
      line_user_id = params['events'][0]['source']['userId']
        
      # LINEボットが登録されていない場合はエラー返す
      unless line_bot then
        render json: { status: 404, message: 'LINEボットが登録されていません。' }
        debug('LINEボットが登録されていません。')
        return
      end
      
      # 既に登録済みの場合は409を返す
      if LineBotFriend.where(line_user_id: line_user_id, line_bot_id: line_bot.id).first then
        render json: { status: 409, message: '既に登録済みです。' }
        debug('既に登録済みです。')
        return
      end
      
      client(line_bot.line_channel_secret, line_bot.line_channel_token)
      profile = JSON.parse(@client.get_profile(line_user_id).body)
      
      line_bot_friend = LineBotFriend.create(
        line_bot: line_bot,
        line_user_id: line_user_id,
        name: profile['displayName'],
        picture_url: profile['pictureUrl']
      )

    end
  end
end
