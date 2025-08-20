class ActivitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  before_action :set_activity, only: [:show]

  def index
    @activities = Activity.all
    # @trips = user_signed_in? ? current_user.trips : Trip.none
   # @activities = Activity.includes(:category, :user).order(created_at: :desc)
    @trips = user_signed_in? ? current_user.trips.order(created_at: :desc) : Trip.none
  end

  def new
    @activity = Activity.new
  end

  def show
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.user = current_user

    if @activity.save
      redirect_to activities_path, notice: "activity created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :category_id)
  end
end
