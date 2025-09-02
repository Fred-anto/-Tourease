class User < ApplicationRecord
  acts_as_favoritor

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :activities, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :trip_users, dependent: :destroy
  has_many :trips, through: :trip_users
  has_many :conversation_users
  has_many :conversations, through: :conversation_users
  has_many :private_messages

  has_one_attached :avatar

  # validates :email, :username, :age, :phone_number, presence: true
  # validates :email, :username, :phone_number, uniqueness: true
end

