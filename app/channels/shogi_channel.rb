class ShogiChannel < ApplicationCable::Channel
  def subscribed
    stream_from "shogi_channel_#{params[:room_id]}"

    serialize_user = current_user.as_json

    is_duplicate = redis.lrange("shogi_channel_#{params[:room_id]}", 0, -1).any? do |user|
      if JSON.parse(user)['id'] == current_user.id
    end
    
    # 再入室の場合はreturn
    return if is_duplicate

    # redisnにroom_idをkeyに配列で入室者情報を保存
    redis = Redis.new
    redis.rpush("shogi_channel_#{params[:room_id]}", current_user.to_json)
  end

  def unsubscribed
    # redisから退出者を削除
    redis = Redis.new
    subscribers = redis.lrange("shogi_channel_#{params[:room_id]}", 0, -1)

    subscribers.each_with_index do |subscriber, index|
      if JSON.parse(subscriber)['id'] == current_user.id
        redis.lrem("shogi_channel_#{params[:room_id]}", index, subscriber)
      end
    end
  end
end
