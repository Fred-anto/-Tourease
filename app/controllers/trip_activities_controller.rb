class TripActivitiesController < ApplicationController
  before_action :set_trip_activity, only: [:show]

  def index
    @trip_activities = TripActivity.all
  end

  def show
  end

  private

  def set_trip_activity
    @trip_activity = TripActivity.find(params[:id])
  end

end
