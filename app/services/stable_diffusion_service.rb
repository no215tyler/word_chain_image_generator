require 'httparty'
require 'base64'

class StableDiffusionService
  # カスタム例外クラスの定義
  class RetryableError < StandardError; end

  class ServiceError < StandardError
    attr_reader :status_code

    def initialize(message, status_code = nil)
      super(message)
      @status_code = status_code
    end
  end

  API_URL = "https://api-inference.huggingface.co/models/stablediffusionapi/breakdomainxl-v6"
  HEADERS = {
    "Authorization" => ENV['STABLE_DIFFUSION_API_KEY']
  }
  TIMEOUT_SECONDS = 60 # タイムアウト時間の設定
  MAX_RETRY_ATTEMPTS = 4 # 最大リトライ回数

  def self.query(prompt, negative_prompt = nil, start_time = Time.now, retry_count = 0)
    payload = if negative_prompt
                { inputs: prompt, parameters: { negative_prompt: negative_prompt } }
              else
                { inputs: prompt }
              end

    begin
      response = HTTParty.post(API_URL, body: payload.to_json, headers: HEADERS, timeout: TIMEOUT_SECONDS)
      if response.code == 200
        return response.body, response.code
      else
        raise RetryableError, "API response code: #{response.code}"
      end
    rescue Net::ReadTimeout, HTTParty::Error, RetryableError => e
      if retry_count <= MAX_RETRY_ATTEMPTS
        retry_count += 1
        sleep_time = 2 ** retry_count # 指数バックオフでの待機時間を設定
        puts "リトライします。エラー: #{e.message}、リトライ回数: #{retry_count}、次のリトライまでの待機時間: #{sleep_time}秒"
        sleep sleep_time
        query(prompt, negative_prompt, start_time, retry_count)
      else
        return "", response&.code || 500
      end
    rescue StandardError => e
      puts "予期しないエラーが発生しました: #{e.message}"
      return "", response&.code || 500
    end
  end
end
