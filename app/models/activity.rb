class Activity < ApplicationRecord
  acts_as_favoritable
  has_one_attached :photo
  belongs_to :category
  belongs_to :user

  validates :name, :description, :address, :photo, presence: true
  validates :name, uniqueness: true
end
