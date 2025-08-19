class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def new
    @trip = Trip.new
  end

  def show
    @trip
  end

  def create
    @trip = Trip.new(trip_params)
    if trip.save
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
    params.require(:trip).permit(:destination, :start_date, :end_date, :mood)
  end
end
