Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  post "login" => "users#login"
  post "signup" => "users#signup"
  post "logout" => "users#logout"
  get "user/search" => "users#searchUser"
  
  get "user/:user_id/userGroups" => "user_group#index"
  post "user/:user_id/userGroup" => "user_group#create"
  post "userGroup/:user_group_id/addUser" => "user_group#addUser"
  delete "userGroup/:user_group_id" => "user_group#deleteUserGroup"
  delete "userGroup/:user_group_id/user/:user_id" => "user_group#deleteUser"
  
  post "user/:user_id/lineBot" => "line#createLineBot"
  get "user/:user_id/lineBot" => "line#indexLineBot"
  put "user/:user_id/lineBot/:line_bot_id/reacquisition" => "line#reacquisitionLineBot"
  
  get "user/:user_id/store" => "store#index"
  post "user/:user_id/store/:store_id/interest" => "store#interest"

  post "user/:user_id/store/:store_id/lineAccount/:line_account_id/lineSendMessage" => "line#sendMessage"
  post "webhook" => "line#webhook"
  get "user/:user_id/lineAccount" => "line#indexAccount"
end
