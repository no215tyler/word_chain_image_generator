class ImageGenerate < ApplicationRecord
  validates :word_chain, :prompt, :http_status, presence: true
end
