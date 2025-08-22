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
    system_prompt = "You will receive a message from the chatbot. with a content describing trip activities. Keep the same message structure and content with markdown but clean it to delete interactions."
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
