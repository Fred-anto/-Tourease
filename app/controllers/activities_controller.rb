class ActivitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  before_action :set_activity, only: [:show, :favorite, :unfavorite]

  def index
    @activities = Activity.all
    @markers = @activities.geocoded.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { activity: activity }),
        marker_html: render_to_string(partial: "marker", locals: { activity: activity })
      }
    end

    @trips = user_signed_in? ? current_user.trips.order(created_at: :desc) : Trip.none
    # @favorites = current_user.all_favorites.select { |f| f.favoritable_type == "Activity" }.map(&:favoritable)
    # @activities = Activity.includes(:category, :user).order(created_at: :desc)
    # @trips = user_signed_in? ? current_user.trips.order(created_at: :desc) : Trip.none
  end
   # @trips = user_signed_in? ? current_user.trips : Trip.none
   # @activities = Activity.includes(:category, :user).order(created_at: :desc)

  def new
    @activity = Activity.new
  end

  def show
    @trip = Trip.find(params[:trip_id]) if params[:trip_id].present?
    @trip_activity = @trip.trip_activities.find_by(activity_id: @activity.id) if params[:trip_id].present?
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.user = current_user
    if @activity.save
      redirect_to my_activities_activities_path, notice: "activity created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def favorite
    current_user.favorite(@activity)
    redirect_to my_activities_activities_path, notice: "Added to fav!"
  end

  def unfavorite
    current_user.unfavorite(@activity)
    redirect_to my_activities_activities_path, notice: "Deleted from fav"
  end

  def my_activities
    @favorite_activities = current_user.all_favorites.select { |f| f.favoritable_type == "Activity" }.map(&:favoritable)
    @created_activities = current_user.activities
    @favorite_activities ||= []
    @created_activities ||= []
  end

  def trip_activities
    @favorite_activities = current_user.all_favorites.select { |f| f.favoritable_type == "Activity" }.map(&:favoritable)
    @created_activities = current_user.activities
    @favorite_activities ||= []
    @created_activities ||= []
  end

  def destroy
   @activity = current_user.activities.find(params[:id])
   @activity.destroy
   redirect_back fallback_location: my_activities_activities_path, notice: "Activity deleted."
  end

  def choose_trip
    @activity = Activity.find(params[:id])
    @trips = current_user.trips.where("end_date > ?", Date.today)
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :category_id, :photo)
  end
end
