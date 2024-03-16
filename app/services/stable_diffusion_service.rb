require 'httparty'
require 'base64'

class StableDiffusionService
  API_URL = "https://api-inference.huggingface.co/models/cagliostrolab/animagine-xl-3.0"
  HEADERS = {
    "Authorization" => ENV['STABLE_DIFFUSION_API_KEY']
  }

  def self.query(prompt, negative_prompt = nil)
    payload = if negative_prompt
                { inputs: prompt, parameters: { negative_prompt: negative_prompt } }
              else
                { inputs: prompt }
              end

    response = HTTParty.post(API_URL, body: payload.to_json, headers: HEADERS)

    if response.success?
      return response.body
    else
      raise StandardError, "API呼び出しでエラーが発生しました。"
    end
  rescue StandardError => e
    raise StandardError, "API呼び出しでエラーが発生しました: #{e.message}"
  end
end
