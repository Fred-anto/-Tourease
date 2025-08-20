class Trip < ApplicationRecord
  has_many :trip_activities, dependent: :destroy
  has_many :activities, through: :trip_activities

  has_many :trip_categories, dependent: :destroy
  has_many :categories, through: :trip_categories

  validates :destination, :start_date, :end_date, :mood, presence: true
end
