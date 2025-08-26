class Message < ApplicationRecord
  belongs_to :chat
  has_one :user, through: :chat
  has_one :trip, through: :chat

 
end
