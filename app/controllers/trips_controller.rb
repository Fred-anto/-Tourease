class TripsController < ApplicationController
  before_action :set_trip, only: [:show]

  def index
    @trips = Trip.all
  end

  def new
    @trip = Trip.new
  end

  def show
  end

  def create
    @trip = Trip.new(trip_params)
    @activity.user = current_user
    if @trip.save
      redirect_to @trip, notice: "trip created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name, :destination, :start_date, :end_date, :mood)
  end
end
