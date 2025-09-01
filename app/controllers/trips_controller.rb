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
    @chats = current_user.chats.where(trip: @trip).order(:created_at)

    @calendar_start_date =
      if params[:start_date].present?
        Date.parse(params[:start_date])
      elsif @trip.start_date.present?
        @trip.start_date.to_date
      else
        Date.current
      end
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
    trip_plan = JSON.parse(params[:content])

    unless trip_plan.values.all? { |activities| activities.is_a?(Array) }
      return redirect_to trips_path, alert: "Non scheduled message can't be saved."
    end

    trip_plan.each do |day, activities|
      create_trip_activities(activities)
    end

    redirect_to @trip, notice: "Saved to trip!"
  end

  private

  def create_trip_activities(activities)
    existing_activity_ids = @trip.trip_activities.pluck(:activity_id)

    activities.each do |activity|
      real_activity = Activity.find_by(id: activity["id"])
      next unless real_activity
      next if existing_activity_ids.include?(real_activity.id)

      TripActivity.create(
        trip: @trip,
        activity: real_activity,
        start_date_time: activity["start_date_time"],
        end_date_time: activity["end_date_time"]
      )
    end
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name, :destination, :start_date, :end_date, :mood, category_ids: [])
  end
end
