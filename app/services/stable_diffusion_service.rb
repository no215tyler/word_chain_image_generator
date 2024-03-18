require 'httparty'
require 'base64'

class StableDiffusionService
  API_URL = "https://api-inference.huggingface.co/models/stablediffusionapi/breakdomainxl-v6"
  HEADERS = {
    "Authorization" => ENV['STABLE_DIFFUSION_API_KEY']
  }
  TIMEOUT_SECONDS = 60 # タイムアウト時間の設定

  def self.query(prompt, negative_prompt = nil)
    payload = if negative_prompt
                { inputs: prompt, parameters: { negative_prompt: negative_prompt } }
              else
                { inputs: prompt }
              end

    response = HTTParty.post(API_URL, body: payload.to_json, headers: HEADERS, timeout: TIMEOUT_SECONDS)

    case response.code
    when 200
      return response.body
    when 404
      raise StandardError, "リソースが見つかりません。"
    when 500
      raise StandardError, "サーバー内部エラーが発生しました。"
    else
      raise StandardError, "API呼び出しで予期しないエラーが発生しました。ステータスコード: #{response.code}"
    end
  rescue Net::ReadTimeout => e
    raise StandardError, "リクエストがタイムアウトしました: #{e.message}"
  rescue HTTParty::Error => e
    raise StandardError, "HTTPartyでエラーが発生しました: #{e.message}"
  rescue StandardError => e
    raise StandardError, "API呼び出しでエラーが発生しました: #{e.message}"
  end
end
