class ConversationsController < ApplicationController

  def index
    @conversations = current_user.conversations
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.private_messages.order(:created_at)
    @message = PrivateMessage.new
  end

  def create
    @conversation = Conversation.new
    @conversation.users << current_user
    @conversation.users << User.find(params[:user_id])

    if @conversation.save
      redirect_to @conversation
    else
      redirect_to conversations_path, alert: "Impossible de créer la conversation."
    end
  end
end
