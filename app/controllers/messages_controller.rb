class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a Tour guide I am a tourist visiting Paris.
  Help me plan my trip with daily activities of must-see and trendy spots. Answer in markdown with for each activity:
  - descritpion - start_time - time allocated - One type of activity among:
  Culture, Nature, Sport, Relaxation, Food or Nightlife - and address"
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(role: "user", content: params[:message][:content], chat: @chat)
    if @message.save
      @chat_message = RubyLLM.chat
      # raise
      response = @chat_message.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)
      redirect_to chat_messages_path(@chat)
    else
      render :index
    end
  end

  # private

  # def message_params

end
