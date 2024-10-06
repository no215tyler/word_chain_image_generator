class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def index
  end

  def create
    words = params[:words]
    filtered_words = WordFilterService.filter_words(words)
    return render json: { error: '画像生成エラー:<br>不適切な単語が含まれています' }, status: 406 if words.length != filtered_words.length

    translated_words = TranslationService.translate(filtered_words.join(','))
    filename = translated_words.clone
    puts filename
    translated_words = 'master piece, best quality, ' + translated_words

    image_bytes, http_status, generate_model = generate_image(translated_words)

    user_id = if user_signed_in?
                current_user.id
              else
                2 # ゲストユーザーを定義
              end

    # DBへ保存
    image_generate = ImageGenerate.new(
      user_id:,
      word_chain: words.join(','),
      prompt: filename,
      http_status:,
      generate_model:
    )

    if http_status == 200
      image_generate.image.attach(io: StringIO.new(image_bytes), filename: "#{filename}.jpg", content_type: 'image/jpeg')
      image_data = Base64.encode64(image_bytes)
      response_body = { image: image_data, filename: }
    else
      response_body = { error: "画像生成エラー：<br>ステータスコード：#{http_status}" }
    end
    image_generate.save!
    image_url = "https://word-chain-image-generator.onrender.com/images/#{image_generate.id}"
    shortened_url = TinyUrlService.shorten(image_url)
    response_body[:image_url] = shortened_url
    render json: response_body, status: (http_status == 200 ? :ok : :internal_server_error)
  end

  def term_of_service
  end

  def privacy_policy
  end

  private

  def generate_image(translated_words, generate_model = 'Stable Diffusion')
    negative_prompt = 'EasyNegative, (worst quality, low quality:1.4), lowres, ugly, bad anatomy, nsfw((Not safe for work)), low quality, negative hand-neg, bad anatomy ,extra fingers, fewer fingers, missing fingers ,extra arms, fewer arms, missing arms, extra legs, fewer legs, extra legs ,text ,logo, watermark, text, word, monochrome, rainbow, wood'
    image_bytes, http_status = StableDiffusionService.query(translated_words, negative_prompt)

    if http_status == 429
      generate_model = 'dall-e-3'
      image_bytes, http_status = Dalle3Service.query(translated_words, generate_model)
    end
    if http_status == 429 # レートエラー時はDALL-E2にフォールバック
      generate_model = 'dall-e-2'
      image_bytes, http_status = Dalle3Service.query(translated_words, generate_model)
    end
    [image_bytes, http_status, generate_model]
  end
end
