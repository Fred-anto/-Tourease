class ChatsController < ApplicationController
  def create
    @chat = Chat.new(title: "New Chat")
    @chat.user = current_user
    @trip = Trip.find_by(id: params[:trip_id])
    @chat.trip = @trip if @trip

    if @chat.save
      redirect_to chat_path(@chat)
    else
      render "chats/index"
    end
  end

  def show
    @chat = Chat.find(params[:id])
    @trip = @chat.trip
    @messages = @chat.messages
    @message = Message.new
  end

  def index
    @chats = current_user.chats.all
  end
end
