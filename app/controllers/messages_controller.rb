class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a Tour guide I am a tourist visiting Paris.
  Help me plan my trip with daily activities of must-see and trendy spots. Answer in markdown with for each activity:
  - descritpion - start_time - time allocated - One type of activity among:
  Culture, Nature, Sport, Relaxation, Food or Nightlife - and address"
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(role: "user", content: params[:message][:content], chat: @chat)
    if @message.save
      build_conversation_history
      response = @chat_message.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)
      redirect_to chat_messages_path(@chat)
    else
      render :index
    end
  end

  private

  def build_conversation_history
    @chat_message = RubyLLM.chat
    @chat.messages.each do |message|
      @chat_message.add_message(
        role: message.role,
        content: message.content
      )
    end
  end

  # def message_params
end
