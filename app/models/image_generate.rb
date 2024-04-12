class ImageGenerate < ApplicationRecord
  has_one_attached :image

  validates :word_chain, :prompt, :http_status, presence: true
end
