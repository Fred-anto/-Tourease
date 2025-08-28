class Activity < ApplicationRecord
  acts_as_favoritable
  has_one_attached :photo
  belongs_to :category
  belongs_to :user
  has_many :trip_activities, dependent: :destroy
  has_many :trips, through: :trip_categories

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  validates :name, :description, :address, presence: true

  validates :name, uniqueness: true
end
