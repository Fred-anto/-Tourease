class Chat < ApplicationRecord
  belongs_to :trip
  belongs_to :user
  belongs_to :activities

  has_many :messages, dependent: :destroy
end
