class Category < ApplicationRecord
  has_many :activities

  validates :name, uniqueness: true
  validates :name, presence: true
end
