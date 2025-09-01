class TripActivitiesController < ApplicationController
  before_action :set_trip

  def index
    @categories = @trip.categories.includes(:activities)
    @activities = Activity.where(category: @trip.categories)
  end

  def create
    activity = Activity.find(params[:activity_id])
    @trip_activity = @trip.trip_activities.build(activity: activity)

    if @trip_activity.save
      redirect_to params[:redirect_to] || trip_trip_activities_path(@trip), notice: "Activity added to your trip!"
    else
      redirect_to trip_path(@trip), alert: "❌ Could not add activity."
    end
  end

  def destroy
    trip_activity = @trip.trip_activities.find(params[:id])
    trip_activity.destroy
    redirect_to trip_path(@trip), notice: "🗑️ Activity removed from your trip."
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end
end
