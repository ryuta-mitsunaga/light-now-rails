Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount ActionCable.server => '/shogi_cable'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # post "login" => "users#login"
  post 'signup' => 'users#signup'
  # post "logout" => "users#logout"
  get 'search' => 'users#searchUser'
  put 'user/:id' => 'users#update'
  get 'lineUserId/:line_user_id/isRegistered' => 'users#isRegistered'
  get 'user' => 'users#getUser'

  get 'userGroups' => 'send_group#index'
  post 'userGroup' => 'send_group#create'
  post 'userGroup/:send_group_id/addLineBotFriend' => 'send_group#addLineBotFriend'
  delete 'userGroup/:send_group_id' => 'send_group#deleteSendGroup'
  delete 'userGroup/:send_group_id/lineBotFriend/:line_bot_friend_id' => 'send_group#deleteUser'

  post 'lineBot' => 'line#createLineBot'
  get 'lineBot' => 'line#indexLineBot'
  put 'lineBot/:line_bot_id/reacquisition' => 'line#reacquisitionLineBot'

  get 'store' => 'store#index'
  post 'store/:store_id/interest' => 'store#interest'
  delete 'store/:store_id/interest' => 'store#clearInterest'

  post 'store/:store_id/userGroup/:send_group_id/lineSendMessage' => 'line#sendMessage'
  post 'webhook' => 'line#addLineBotFriend'
  post 'webhook/signup' => 'line#webhookSignup'
  get 'lineAccount' => 'line#indexAccount'
  get 'user/:user_id/lineAccount/linkage' => 'line#linkageLineAccount'

  get 'lineBot/:line_bot_id/friends' => 'line_bot_friend#index'

  # 将棋
  post 'shogi/room/:room_id/log' => 'shogi#addLog'
  get 'shogi/room/:room_id/log/latest' => 'shogi#showLatestLog'

  post 'shogi/room' => 'shogi#createRoom'
  delete 'shogi/room/:shogi_room_id' => 'shogi#deleteRoom'

  get 'shogi/rooms' => 'shogi#indexRooms'
  get 'shogi/room/:shogi_room_id' => 'shogi#showRoom'
end
