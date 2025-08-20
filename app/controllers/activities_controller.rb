class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show]

  def index
    @activities = Activity.all
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
