require 'httparty'
require 'base64'

class StableDiffusionService
  # カスタム例外クラスの定義
  class RetryableError < StandardError; end

  API_URL = "https://api-inference.huggingface.co/models/stablediffusionapi/breakdomainxl-v6"
  HEADERS = {
    "Authorization" => ENV['STABLE_DIFFUSION_API_KEY']
  }
  TIMEOUT_SECONDS = 60 # タイムアウト時間の設定
  MAX_RETRY_ATTEMPTS = 5 # 最大リトライ回数

  def self.query(prompt, negative_prompt = nil, start_time = Time.now, retry_count = 0)
    payload = if negative_prompt
                { inputs: prompt, parameters: { negative_prompt: negative_prompt } }
              else
                { inputs: prompt }
              end

    begin
      response = HTTParty.post(API_URL, body: payload.to_json, headers: HEADERS, timeout: TIMEOUT_SECONDS)

      case response.code
      when 200
        return response.body
      when 404
        raise StandardError, "リソースが見つかりません。"
      when 500, 503
        raise RetryableError, "サーバー内部エラーまたはサービス利用不可エラーが発生しました。ステータスコード: #{response.code}"
      else
        raise StandardError, "API呼び出しで予期しないエラーが発生しました。ステータスコード: #{response.code}"
      end
    rescue Net::ReadTimeout, HTTParty::Error, RetryableError => e
      retry_count += 1
      if retry_count <= MAX_RETRY_ATTEMPTS
        sleep_time = 2 ** retry_count # 指数バックオフでの待機時間を設定
        puts "リトライします。エラー: #{e.message}、リトライ回数: #{retry_count}、次のリトライまでの待機時間: #{sleep_time}秒"
        sleep sleep_time
        query(prompt, negative_prompt, start_time, retry_count)
      else
        raise StandardError, "リトライの最大試行回数に達しました: #{e.message}"
      end
    rescue StandardError => e
      raise StandardError, "API呼び出しでエラーが発生しました: #{e.message}"
    end
  end
end
