class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(role: "user", content: params[:message][:content], chat: @chat)

    if @message.save
      @user = @chat.user
      system_prompt = "You are a Tour guide. I am a #{@user.age} years old tourist visiting Paris.
      Help me plan my trip with daily activities of must-see and trendy spots.
      Answer in bullet points, with for each activity:
      - description - start_time - time allocated - One type of activity among:
      Culture, Nature, Sport, stroll, Food or Nightlife - and address"

      @chat_message = RubyLLM.chat
      response = @chat_message.with_instructions(system_prompt).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_messages_path(@chat)
    else
      render "chats/index"
    end
  end
end
