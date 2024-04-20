class ImageGenerate < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  validates :word_chain, :prompt, :http_status, presence: true
end
