class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: [:show, :save_message]

  def index
    @trips = current_user.trips
  end

  def new
    @trip = Trip.new
  end

  def show
    @chats = current_user.chats
                         .where(trip: @trip)
                         .order(:created_at)
  end

  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      TripUser.create(user: current_user, trip: @trip)
      redirect_to @trip, notice: "Trip created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    redirect_to activities_path, notice: "Trip deleted successfully!"
  end

  def save_message
    @chat_message = RubyLLM.chat
    system_prompt = "You will receive a message describing a multi-day trip itinerary with activities listed day by day.
    Task:
    - Keep the same day-by-day structure with Markdown formatting.
    - For each activity, keep only these details:
      - description
      - start_time
      - time allocated (duration)
      - one type of activity among: Culture, Nature, Sport, Stroll, Food, or Nightlife
      - address
    - Remove any extra comments, tips, or conversational phrases (e.g., 'Enjoy your trip!').
    - Keep the content factual and clean, without adding new information."
    response = @chat_message.with_instructions(system_prompt).ask(params[:content])
    @trip.update(description: response.content)
    redirect_to @trip, notice: "Saved to trip!"
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name, :destination, :start_date, :end_date, :mood)
  end
end
