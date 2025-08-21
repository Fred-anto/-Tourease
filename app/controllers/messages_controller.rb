class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    if @chat.trip
      @trip = @chat.trip
    end
    @message = Message.new(role: "user", content: params[:message][:content], chat: @chat)
    if @message.save
      build_conversation_history
      @chat_message.ask(@message.content)
      @user = @chat.user
      system_prompt = "You are a Tour guide. I am a #{@user.age} years old tourist visiting #{@trip.destination}.
      Help me plan my #{@trip.mood} trip with daily activities of must-see and trendy spots.
      Answer in bullet points, with for each activity:
      - description - start_time - time allocated - One type of activity among:
      Culture, Nature, Sport, stroll, Food or Nightlife - and address"
      response = @chat_message.with_instructions(system_prompt).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      if @chat.title == "Untitled"
        @chat.title == @trip.name
      end
      redirect_to chat_path(@chat)
    else
      render "chats/index"
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
end
