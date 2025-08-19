class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :activities
  has_many :trips, through: :trip_users

  validates :mail, :username, :age, :phone_number, presence: true
  validates :mail, :username, :phone_number, uniqueness: true
end
