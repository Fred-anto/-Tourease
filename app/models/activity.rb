class Activity < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :name, :description, :address, presence: true
  validates :name, uniqueness: true
end
