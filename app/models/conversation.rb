class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users
  has_many :private_messages, dependent: :destroy

  validates :users, length: { minimum: 2 }
end
