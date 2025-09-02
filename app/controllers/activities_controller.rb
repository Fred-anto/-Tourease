class ActivitiesController < ApplicationController
  # Devise : on laisse index/show publics, le reste nécessite d'être connecté
  skip_before_action :authenticate_user!, only: [:index, :show]

  # On a besoin de @activity pour show/favorite/unfavorite
  before_action :set_activity, only: [:show, :favorite, :unfavorite]

  def index
    # Précharge category, user (+ avatar) et photo pour éviter les N+1 dans les vues & partials
    @activities = Activity
                    .with_attached_photo
                    .includes(:category, user: { avatar_attachment: :blob })

    @markers = @activities.geocoded.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { activity: activity }),
        marker_html: render_to_string(partial: "marker", locals: { activity: activity })
      }
    end

    @trips = user_signed_in? ? current_user.trips.order(created_at: :desc) : Trip.none
  end

  def new
    @activity = Activity.new
  end

  def show
    if params[:trip_id].present?
      @trip = Trip.find(params[:trip_id])
      @trip_activity = @trip.trip_activities.find_by(activity_id: @activity.id)
    end
  end

  def create
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      redirect_to my_activities_activities_path, notice: "activity created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def favorite
    current_user.favorite(@activity)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @activity }
    end
  end

  def unfavorite
    current_user.unfavorite(@activity)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @activity }
    end
  end

  def my_activities
    @favorite_activities = current_user.all_favorites
                                       .select { |f| f.favoritable_type == "Activity" }
                                       .map(&:favoritable)
    @created_activities = current_user.activities
    @favorite_activities ||= []
    @created_activities ||= []
  end

  def trip_activities
    @favorite_activities = current_user.all_favorites
                                       .select { |f| f.favoritable_type == "Activity" }
                                       .map(&:favoritable)
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
    @activity = Activity
                  .with_attached_photo
                  .includes(:category, user: { avatar_attachment: :blob })
                  .find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :category_id, :photo)
  end
end
