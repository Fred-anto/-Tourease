class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])

    if @chat.trip
      @trip = @chat.trip
    end

    @message = @chat.messages.new(role: "user", content: params[:message][:content])

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
      @chat.messages.create(role: "assistant", content: response.content)

      @chat.generate_title_from_first_message if @chat.title == "Untitled"

      respond_to do |format|
        format.turbo_stream # va chercher `app/views/messages/create.turbo_stream.erb`
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_message",
            partial: "messages/form",
            locals: { chat: @chat, message: @message }
          )
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
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
