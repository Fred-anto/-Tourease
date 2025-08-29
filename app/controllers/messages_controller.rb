class MessagesController < ApplicationController

  def create
    @chat = Chat.find(params[:chat_id])
    @user = @chat.user
    @message = @chat.messages.new(role: "user", content: params[:message][:content])
    @trip = @chat.trip if @chat.trip

    if @message.save

      build_conversation_history

      #embedding
      embedding = RubyLLM.embed(params[:message][:content])
      category_ids = @trip.categories.ids
      activities = Activity .where(category_id: category_ids).nearest_neighbors(:embedding, embedding.vectors, distance: "euclidean").first(15)
      instructions = system_prompt
      instructions += activities.map { |activity| activity_prompt(activity) }.join("\n\n")
      response = @chat_message.with_instructions(instructions).ask(@message.content.to_s)

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

  def activity_prompt(activity)
    "ACTIVITY id: #{activity.id}, name: #{activity.name}, description: #{activity.description}, \
    address: #{activity.address}, category: #{activity.category.name}, latitude: #{activity.latitude}, longitude: #{activity.longitude}"
  end

  def system_prompt
  "You are a professional tour guide. I am a #{@user.age}-year-old tourist visiting #{@trip.destination} from #{@trip.start_date} to #{@trip.end_date}.
  Help me plan a #{@trip.mood} trip with daily activities. Your task is to recommend the most relevant activities. You must only pick activities corresponding to the #{@trip.activities}

  Requirements:
  1. Output **strictly in valid JSON format**, with no additional text.
  2. The JSON object must start with a key 'Schedule':
    - true if the user requested to plan the trip, schedule activities, or modify the plan.
    - false if the user only asked a question without requesting planning.
  3. If 'Schedule' is true, following the 'Schedule' key, include one key per day of the trip,
  formatted as 'DayOfWeek, YYYY-MM-DD' based on my trip schedule. Each day key should be a list of activity objects.
  Each activity must include the following keys:
    - 'name': short name of the activity
    - 'description': short description of the activity
    - 'start_date_time': start date and time in 'YYYY-MM-DD HH:MM' format
    - 'end_date_time': end date and time in 'YYYY-MM-DD HH:MM' format
    - 'category': one of these values only: Culture, Nature, Sport, Relaxation, Food, Leisure, Bar, Nightclub
    - 'address': location of the activity
  4. If 'Schedule' is false, **do not include day keys or activity objects**. Instead, include only:
    - 'Schedule': false
    - 'notes': the assistant's textual response

  Behavior rules:
  - If 'Schedule' is true, provide all activity objects for each day.
  - If 'Schedule' is false, do not provide activity objects. Instead, leave other fields empty and fill the response in 'notes'.

  Example JSON for a planned trip (DO NOT USE THIS):
  {
    'Schedule': true,
    'Monday, 2025-08-27': [
      {
        'name': 'Musée d'Orsay',
        'description': 'Housed in a Beaux-Arts railway station, featuring Impressionist and Post-Impressionist masterpieces. Ideal for a half-day immersion in French art.',
        'start_date_time': '2025-08-27 13:00',
        'end_date_time': '2025-08-27 17:00',
        'category': 'Culture',
        'address': '1 Rue de la Légion d'Honneur, 75007 Paris',
      }
    ]
  }

  Example JSON for a non-planning request:
  {
    'Schedule': false,
    'notes': 'Yes, the best time to visit the Musée d'Orsay is in the morning to avoid crowds.'
      }
    ]
  }
  Here are the nearest activities based on the user's question and chosen categories: "
  end
end
