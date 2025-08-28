class Category < ApplicationRecord
  has_many :activities
  has_many :trip_categories
  has_many :trips, through: :trip_categories
  validates :name, uniqueness: true
  validates :name, presence: true
end
