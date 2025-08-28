class Activity < ApplicationRecord
  acts_as_favoritable
  has_one_attached :photo
  belongs_to :category
  belongs_to :user

  has_neighbors :embedding
  after_create :set_embedding

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  validates :name, :description, :address, presence: true

  validates :name, uniqueness: true

  private

  def set_embedding
    embedding = RubyLLM.embed("Activity: #{name}. Description: #{description}. Address: #{address}. Category: #{category.name}")
    update(embedding: embedding.vectors)
  end
end
