class ShogiController < ApplicationController
  include ActionController::Cookies
  before_action :check_logged_in

  def addLog
    shogi_room = ShogiRoom.find(params[:room_id])

    # 将棋ルームがなければ例外
    throw '将棋ルームがありません' if shogi_room.blank?

    log = ShogiLog.create(
      shogi_room:,
      user_id: @user.id,
      sfen: params[:sfen]
    )

    ActionCable.server.broadcast("shogi_channel_#{params[:room_id]}", { userId: @user.id, sfen: params[:sfen] })

    render json: { status: 'success', data: log }
  end

  def deleteRoom
    shogi_room = ShogiRoom.find(params[:shogi_room_id])

    # 将棋ルームがなければ例外
    throw '将棋ルームがありません' if shogi_room.blank?

    shogi_room.destroy

    render json: { status: 'success' }
  end

  def showLatestLog
    log = ShogiLog.where(shogi_room_id: params[:room_id])
                  .order(:created_at).last
    render json: { status: 'success', data: log }
  end

  def indexRooms
    rooms = ShogiRoom.includes(:user).all

    redis = Redis.new

    witdhJoinUsers = rooms.map do |room|
      join_users = redis.lrange("shogi_channel_#{room.id}", 0, -1).filter_map do |user|
        JSON.parse(user)
      end

      # joinUsersのキーを追加
      {
        id: room.id,
        name: room.name,
        createdUser: room.user,
        joinUsers: join_users
      }
    end

    render json: { status: 'success', data: witdhJoinUsers }
  end

  def createRoom
    room = ShogiRoom.create(
      user: @user,
      name: params[:name]
    )

    render json: { status: 'success', data: room }
  end
end
