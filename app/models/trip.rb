class Trip < ApplicationRecord
  has_many :trip_activities, dependent: :destroy
  has_many :activities, through: :trip_activities

  has_many :trip_categories, dependent: :destroy
  has_many :categories, through: :trip_categories

  has_many :trip_users,      dependent: :destroy
  has_many :users,           through: :trip_users
  has_one :chat, dependent: :destroy
  validates :name, :destination, :start_date, :end_date, :mood, presence: true
end
