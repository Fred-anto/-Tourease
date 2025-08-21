class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: [:show]

  def index
    @trips = current_user.trips
  end

  def new
    @trip = Trip.new
  end

  def show
  end

  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      TripUser.create(user: current_user, trip: @trip)
      redirect_to @trip, notice: "trip created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    redirect_to activities_path, notice: "Trip deleted successfully!"
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name, :destination, :start_date, :end_date, :mood)
  end
end
