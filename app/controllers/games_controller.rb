class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def index
  end

  def create
    words = params[:words].join(", ")
    translated_words = TranslationService.translate(words)
    puts translated_words
    translated_words.prepend("master piece, best quality, ")
    negative_prompt = "EasyNegative, (worst quality, low quality:1.4), lowres, ugly, bad anatomy, nsfw((Not safe for work)), low quality, negative hand-neg, bad anatomy ,extra fingers, fewer fingers, missing fingers ,extra arms, fewer arms, missing arms, extra legs, fewer legs, extra legs ,text ,logo, watermark, text, word, monochrome, rainbow, wood"
    image_bytes = StableDiffusionService.query(translated_words, negative_prompt)
    image_data = Base64.encode64(image_bytes)
    render json: { image: image_data }
  end
end
