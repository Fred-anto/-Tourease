class Category < ApplicationRecord
  has_many :activities, dependent: :destroy
  has_many :trip_categories, dependent: :destroy
  has_many :trips, through: :trip_categories
  validates :name, uniqueness: true
  validates :name, presence: true
end
