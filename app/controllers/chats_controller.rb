class ChatsController < ApplicationController
  def create
    @chat = Chat.new(title: "Untitled")
    @chat.user = current_user
    @chat.save
    redirect_to chat_path(@chat)
  end

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @message = Message.new
  end

  def index
    @chats = current_user.chats.all
  end
end
