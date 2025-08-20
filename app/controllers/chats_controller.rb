class ChatsController < ApplicationController
  def new
    @chat = Chat.new
    redirect_to chat_path(@chat)
  end

  def create
    @chat = current_user.chats.create
    redirect_to @chat
  end

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @message = Message.new
  end
end
