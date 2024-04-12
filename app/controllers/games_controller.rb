class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def index
  end

  def create
    words = params[:words]
    filtered_words = WordFilterService.filter_words(words)
    translated_words = TranslationService.translate(filtered_words.join(","))
    filename = translated_words.clone
    puts filename
    translated_words = "master piece, best quality, " + translated_words

    image_bytes, http_status, generate_model = generate_image(translated_words)

    # DBへ保存
    ImageGenerate.create!(
      word_chain: words.join(","),
      prompt: filename,
      http_status: http_status,
      generate_model: generate_model
    )
    # レスポンスの処理
    if http_status == 200
      image_data = Base64.encode64(image_bytes)
      render json: { image: image_data, filename: filename }
    else
      render json: { error: "画像生成エラー：ステータスコード：#{http_status}" }, status: :internal_server_error
    end
  end

  def term_of_service
  end

  def privacy_policy
  end

  private

    def generate_image(translated_words, generate_model = "Stable Diffusion")
      negative_prompt = "EasyNegative, (worst quality, low quality:1.4), lowres, ugly, bad anatomy, nsfw((Not safe for work)), low quality, negative hand-neg, bad anatomy ,extra fingers, fewer fingers, missing fingers ,extra arms, fewer arms, missing arms, extra legs, fewer legs, extra legs ,text ,logo, watermark, text, word, monochrome, rainbow, wood"
      image_bytes, http_status = StableDiffusionService.query(translated_words, negative_prompt)

      if http_status == 429
        generate_model = "dall-e-3"
        image_bytes, http_status = Dalle3Service.query(translated_words, generate_model)
      end
      if http_status == 429 # レートエラー時はDALL-E2にフォールバック
        generate_model = "dall-e-2"
        image_bytes, http_status = Dalle3Service.query(translated_words, generate_model)
      end
      return image_bytes, http_status, generate_model
    end
end
