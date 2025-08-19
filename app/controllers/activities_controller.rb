class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
  end

  def new
    @activity = Activity.new
  end

  def show
    @activity
  end

  def create
    @activity = Activity.new(activity_params)
    if activity.save
      redirect_to @activity, notice: "activity created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address)
  end
end
