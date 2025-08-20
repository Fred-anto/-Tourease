class ChatsController < ApplicationController
  def create
    # @chat = current_user.chats.create
    # redirect_to @chat
    raise
  end

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @message = Message.new
  end
end
