class PrivateMessagesController < ApplicationController
  before_action :set_conversation

  def create
    @message = @conversation.private_messages.new(private_message_params)
    @message.user = current_user

    if @message.save
      redirect_to conversation_path(@conversation)
    else
      @messages = @conversation.private_messages.order(:created_at)
      render "conversations/show", status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def private_message_params
    params.require(:private_message).permit(:content)
  end
end
