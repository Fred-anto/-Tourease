class Review < ApplicationRecord
  belongs_to :activity, counter_cache: true
  belongs_to :user

  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validates :comment, length: { maximum: 2000 }, allow_blank: true

  after_commit :update_activity_avg, on: %i[create update destroy]

  private
  def update_activity_avg
    avg = activity.reviews.where.not(rating: nil).average(:rating)
    activity.update(
      rating_avg: (avg || 0).to_f.round(2),
      reviews_count: activity.reviews.count
    )
  end
end
