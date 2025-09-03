class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @user = @chat.user
    @message = @chat.messages.new(role: "user", content: params[:message][:content])
    @trip = @chat.trip if @chat.trip
    @existing_trip_activities = @trip&.trip_activities&.includes(:activity) || []
    existing_activity_ids = @existing_trip_activities.map { |ta| ta.activity.id }

    if @message.save
      Turbo::StreamsChannel.broadcast_append_to(
        @chat,
        target: "messages",
        html: render_to_string(partial: "messages/message_item", locals: { message: @message, trip: @trip })
      )

      Turbo::StreamsChannel.broadcast_replace_to(
        @chat,
        target: "new_message",
        html: render_to_string(partial: "messages/form", locals: { chat: @chat, message: Message.new })
      )

      build_conversation_history(except: @message)

      embedding = RubyLLM.embed(@message.content.to_s)
      category_ids = @trip.categories.ids
      activities = Activity.where(category_id: category_ids)
                           .where.not(id: existing_activity_ids)
                           .nearest_neighbors(:embedding, embedding.vectors, distance: "euclidean")
                           .first(15)

      existing_activities_text = existing_activities_prompt
      instructions = system_prompt
      instructions += activities.map { |activity| activity_prompt(activity) }.join("\n\n")
      instructions += "\n\nHere are the activities already in the trip : you MUST include any activity that is listed below in your suggestions \n"
      instructions += existing_activities_text unless @existing_trip_activities.empty?
      instructions += "\n\nIMPORTANT: Each activity must be unique.\n\n"

      assistant = @chat.messages.create!(role: "assistant", content: "", parsed_content: nil)
      Turbo::StreamsChannel.broadcast_append_to(
        @chat,
        target: "messages",
        html: render_to_string(partial: "messages/message_item", locals: { message: assistant, trip: @trip })
      )

      stream_ai_answer(assistant: assistant, instructions: instructions, user_prompt: @message.content)

      head :ok
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

  def build_conversation_history(except: nil)
    @chat_message = RubyLLM.chat
    @chat.messages.each do |m|
      next if except && m.id == except.id
      @chat_message.add_message(role: m.role, content: m.content)
    end
  end

  def stream_ai_answer(assistant:, instructions:, user_prompt:)
    buffer = +""
    last_push = Time.now

    if @chat_message.respond_to?(:with_instructions) && @chat_message.respond_to?(:stream)
      @chat_message.with_instructions(instructions).stream(user_prompt.to_s) do |chunk|
        next if chunk.blank?
        buffer << chunk
        throttled_replace(assistant: assistant, content: buffer, last_push: last_push)
        last_push = Time.now
      end
    else
      client = OpenAI::Client.new
      msgs = [{ role: "system", content: instructions }]
      msgs += @chat.messages.order(:created_at).map { |m| { role: m.role, content: m.content } }

      client.chat(parameters: {
        model: "gpt-4o-mini",
        messages: msgs,
        stream: proc { |evt|
          delta = evt.dig("choices", 0, "delta", "content")
          next unless delta
          buffer << delta
          throttled_replace(assistant: assistant, content: buffer, last_push: last_push)
          last_push = Time.now
        }
      })
    end

    broadcast_replace_message(assistant: assistant, content: buffer)

    parsed = safe_parse_json(buffer)
    assistant.update!(content: buffer, parsed_content: parsed)

    html = render_to_string(
      partial: "messages/message_item",
      locals: { message: assistant, trip: @trip }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      @chat,
      target: ActionView::RecordIdentifier.dom_id(assistant),
      html: html
    )

    @chat.generate_title_from_first_message if @chat.title == "New Chat"
  end

  def throttled_replace(assistant:, content:, last_push:)
    return unless Time.now - last_push > 0.04 # ~40ms
    broadcast_replace_message(assistant: assistant, content: content)
  end

  def broadcast_replace_message(assistant:, content:)
    html = render_to_string(
      partial: "messages/message_item",
      locals: { message: assistant.tap { |m| m.content = content; m.parsed_content = nil }, trip: @trip }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      @chat,
      target: ActionView::RecordIdentifier.dom_id(assistant),
      html: html
    )
  end

  def safe_parse_json(text)
    JSON.parse(text)
  rescue JSON::ParserError
    nil
  end

  def activity_prompt(activity)
    "ACTIVITY id: #{activity.id}, name: #{activity.name}, description: #{activity.description}, " \
    "address: #{activity.address}, category: #{activity.category.name}, latitude: #{activity.latitude}, longitude: #{activity.longitude}"
  end

  def existing_activities_prompt
    @existing_trip_activities.map { |ta| activity_prompt(ta.activity) }.join("\n\n")
  end

  def system_prompt
    "You are a professional tour guide. I am a #{@user.age}-year-old tourist visiting #{@trip.destination} from #{@trip.start_date} to #{@trip.end_date}.
    Help me plan a #{@trip.mood} trip with daily activities. Your task is to recommend the most relevant activities.
    Requirements:
    1. Output **strictly in valid JSON format**, with no additional text.
    2. The JSON object must start with a key 'Schedule':
      - true if the user requested to plan the trip, schedule activities, or modify the plan.
      - false if the user only asked a question without requesting planning.
    3. If 'Schedule' is true, following the 'Schedule' key, include one key per day of the trip.
    Each day key must be formatted strictly as 'YYYY-MM-DD' (do not include the day of week). Each day key should be a list of activity objects.
    Each activity must include the following keys:
      - 'id': Id of the record given to you
      - 'name': short name of the activity
      - 'description': short description of the activity
      - 'start_date_time': start date and time in 'YYYY-MM-DD HH:MM' format
      - 'end_date_time': end date and time in 'YYYY-MM-DD HH:MM' format
      - 'category': one of these values only: Culture, Nature, Sport, Relaxation, Food, Leisure, Bar, Nightclub
      - 'address': location of the activity
      - Sort and display the results by date and time.
    4. If 'Schedule' is false:
     - Do not include day keys or activity objects.
     - Include only:
        - 'Schedule': false
        - 'notes': textual response appropriate to the user's message

      Example JSON if 'Schedule': false:
      {
        'Schedule': false,
        'notes': 'Hello! How can I help you with your trip planning today?'
      }

      Example JSON for a planned trip:
      {
        'Schedule': true,
        '2025-08-25': [
          {
            'id': 34,
            'name': 'Musée d'Orsay',
            'description': 'Housed in a Beaux-Arts railway station, featuring Impressionist and Post-Impressionist masterpieces. Ideal for a half-day immersion in French art.',
            'start_date_time': '2025-08-27 13:00',
            'end_date_time': '2025-08-27 17:00',
            'category': 'Culture',
            'address': '1 Rue de la Légion d'Honneur, 75007 Paris',
          }
        ]
      }

    Behavior rules:
  - Only output **valid JSON**. No extra text or formatting.
  - If 'Schedule' is false, do not leave 'notes' empty; always provide a meaningful response.
  - If 'Schedule' is true, provide all activity objects for each day, including any activities already in the trip.
  - Each activity must be unique.
  - Always sort activities by start_date_time.

  You must only suggest activities that are below and/or are already in the trip.
  Here are the nearest activities based on the user's question and chosen categories: "
  end
end
