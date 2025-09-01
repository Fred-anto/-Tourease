class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users
  has_many :private_messages, dependent: :destroy

  validates :title, presence: true

  scope :between, ->(user_id1, user_id2) {
    joins(:conversation_users)
      .where(conversation_users: { user_id: [user_id1, user_id2] })
      .group("conversations.id")
      .having("COUNT(conversations.id) = 2")
  }
end
