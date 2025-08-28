class TripActivity < ApplicationRecord
  belongs_to :activity
  belongs_to :trip
  has_one :category
end
