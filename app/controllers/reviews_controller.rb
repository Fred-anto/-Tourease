# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :set_activity
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_review, only: [:update, :destroy]

  # GET /activities/:activity_id/reviews
  # Page d’évaluation : formulaire + historique
  def index
    @review  = user_signed_in? ? (@activity.reviews.find_by(user: current_user) || @activity.reviews.new) : @activity.reviews.new
    @reviews = @activity.reviews
                        .includes(user: { avatar_attachment: :blob }) # si User a has_one_attached :avatar
                        .order(created_at: :desc)
  end

  # POST /activities/:activity_id/reviews
  def create
    @review = @activity.reviews.find_or_initialize_by(user: current_user)
    @review.assign_attributes(review_params)

    if @review.save
      respond_to do |format|
        format.turbo_stream  # => rend app/views/reviews/create.turbo_stream.erb
        format.html { redirect_to activity_reviews_path(@activity), notice: "Merci pour votre avis !" }
      end
    else
      @reviews = @activity.reviews.includes(:user).order(created_at: :desc)
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      respond_to do |format|
        # On renvoie la page d'index avec un 422 (Turbo remplacera le document si nécessaire)
        format.turbo_stream { render :index, status: :unprocessable_entity }
        format.html        { render :index, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/:activity_id/reviews/:id
  def update
    if @review.update(review_params)
      respond_to do |format|
        format.turbo_stream  # => rend app/views/reviews/update.turbo_stream.erb
        format.html { redirect_to activity_reviews_path(@activity), notice: "Avis mis à jour." }
      end
    else
      @reviews = @activity.reviews.includes(:user).order(created_at: :desc)
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      respond_to do |format|
        format.turbo_stream { render :index, status: :unprocessable_entity }
        format.html        { render :index, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/:activity_id/reviews/:id
  def destroy
    @review.destroy
    respond_to do |format|
      format.turbo_stream  # => rend app/views/reviews/destroy.turbo_stream.erb
      format.html { redirect_to activity_reviews_path(@activity), notice: "Avis supprimé." }
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def set_review
    @review = @activity.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
