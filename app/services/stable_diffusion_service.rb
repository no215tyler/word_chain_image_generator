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

  def self.query(prompt, negative_prompt = nil, start_time = Time.now)
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
      when 500, 503 # 500 および 503 エラーを再試行対象とする
        raise RetryableError, "サーバー内部エラーまたはサービス利用不可エラーが発生しました。ステータスコード: #{response.code}"
      else
        raise StandardError, "API呼び出しで予期しないエラーが発生しました。ステータスコード: #{response.code}"
      end
    rescue Net::ReadTimeout, HTTParty::Error, RetryableError => e
      if Time.now - start_time < TIMEOUT_SECONDS
        puts "リトライします。エラー: #{e.message}"
        sleep 5 # 少し待ってから再試行
        retry
      else
        raise StandardError, "最終的にリクエストがタイムアウトしました: #{e.message}"
      end
    rescue StandardError => e
      raise StandardError, "API呼び出しでエラーが発生しました: #{e.message}"
    end
  end
end
