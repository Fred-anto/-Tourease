class Activity < ApplicationRecord
  acts_as_favoritable
  has_one_attached :photo

  belongs_to :category
  belongs_to :user

  has_many :trip_activities, dependent: :destroy
  has_many :trips, through: :trip_activities

  # Association aux reviews
  has_many :reviews, dependent: :destroy

  has_neighbors :embedding
  after_create :set_embedding

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  validates :name, :description, :address, presence: true
  validates :name, uniqueness: true

  # Pour calculer la moyenne et le nb de commentaires
  def recompute_rating!
    avg = reviews.where.not(rating: nil).average(:rating)
    update!(
      reviews_count: reviews.count,
      rating_avg: (avg || 0).to_f.round(2)
    )
  end

  private

  def set_embedding
    embedding = RubyLLM.embed("Activity: #{name}. Description: #{description}. Address: #{address}. Category: #{category.name}")
    update(embedding: embedding.vectors)
  end
end
