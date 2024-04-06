class ChatChannel < ApplicationCable::Channel
 
  def subscribed
    stream_from "chat_channel_#{params[:chat_id]}"
  end
 
  def broadcast_message
    channel = "chat_channel_#{params[:chat_id]}"
 
    ActionCable.server.broadcast channel, message: 'ブロードキャストしています。'
  end
end
