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
      system_prompt = "You are a Tour guide. I am a #{@user.age} years old tourist visiting
       #{@trip.destination} from #{@trip.start_date} to #{@trip.end_date}.
      Help me plan my #{@trip.mood} trip with daily activities of must-see and trendy spots.
      Each day should be labeled with the day of the week and the date, based on my trip schedule: from #{@trip.start_date} to #{@trip.end_date}.
      Output strictly in JSON format, with no additional text.
      Provide a list of activities.
      Very important, your message MUST be a valid JSON
      Each activity must include the following keys:
      'Schedule' - set this value to true only when the user ask you to plan for activites
      'name' - short name of the activity
      'description' - short description of the activity
      'start_date_time' - start date and time in the format YYYY-MM-DD HH:MM
      'end_date_time' - end date and time in the format YYYY-MM-DD HH:MM
      'category' - choose one and only one among: Culture, Nature, Sport, Relaxation, Food, or Nightlife
      'address' - location of the activity.
      'notes' - Fill this key only when the user doesn't ask for an activity with your response"


      response = @chat_message.with_instructions(system_prompt).ask(@message.content.to_s)
      @chat.messages.create(role: "assistant", content: response.content, parsed_content: JSON.parse(response.content))

      @chat.generate_title_from_first_message if @chat.title == "New Chat"

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
