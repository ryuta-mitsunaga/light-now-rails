Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  # post "login" => "users#login"
  post "signup" => "users#signup"
  # post "logout" => "users#logout"
  get "search" => "users#searchUser"
  put "user/:id" => "users#update"
  get "lineUserId/:line_user_id/isRegistered" => "users#isRegistered"
  get "user" => "users#getUser"
  
  get "userGroups" => "user_group#index"
  post "userGroup" => "user_group#create"
  post "userGroup/:user_group_id/addUser" => "user_group#addUser"
  delete "userGroup/:user_group_id" => "user_group#deleteUserGroup"
  delete "userGroup/:user_group_id/user/:user_id" => "user_group#deleteUser"
  
  post "lineBot" => "line#createLineBot"
  get "lineBot" => "line#indexLineBot"
  put "lineBot/:line_bot_id/reacquisition" => "line#reacquisitionLineBot"
  
  get "store" => "store#index"
  post "store/:store_id/interest" => "store#interest"
  delete "store/:store_id/interest" => "store#clearInterest"

  post "store/:store_id/userGroup/:user_group_id/lineSendMessage" => "line#sendMessage"
  post "webhook" => "line#webhook"
  get "lineAccount" => "line#indexAccount"
  get "user/:user_id/lineAccount/linkage" => "line#linkageLineAccount"
end
