class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show]

  def index
    @conversations = current_user.conversations.order(updated_at: :desc)
  end

  def show
    @messages = @conversation.private_messages.order(:created_at)
    @message = PrivateMessage.new
  end

  def find_or_create
    other_user = User.find(params[:user_id])

    @conversation = Conversation.between(current_user.id, other_user.id).first_or_create! do |c|
      c.title = "Chat with #{other_user.username}"
      c.users << current_user
      c.users << other_user
    end

    redirect_to conversation_path(@conversation)
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
end
