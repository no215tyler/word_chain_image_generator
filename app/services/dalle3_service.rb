require 'httparty'
require 'base64'

class Dalle3Service
  API_URL = "https://api.openai.com/v1/images/generations"
  HEADERS = {
    "Authorization" => "Bearer #{ENV['OPENAI_API_KEY']}",
    "Content-Type" => "application/json"
  }
  TIMEOUT_SECONDS = 60

  def self.query(prompt, model)
    payload = {
      model: model,
      prompt: prompt,
      n: 1,
      size: "1024x1024",
      quality: "standard"
    }

    begin
      response = HTTParty.post(API_URL, body: payload.to_json, headers: HEADERS, timeout: TIMEOUT_SECONDS)
      if response.code == 200
        # DALL-E3 APIは画像のURLを返すのでそれを使用して画像をダウンロードする
        image_url = response.parsed_response["data"][0]["url"]
        image_response = HTTParty.get(image_url)
        return image_response.body, response.code
      elsif response.code == 429
        puts "DALL-E3のレート制限に達しました。DALL-E2モデルへフォールバックします。"
        ['x-ratelimit-limit-requests', 'x-ratelimit-remaining-requests', 'x-ratelimit-reset-requests', 'x-ratelimit-limit-tokens', 'x-ratelimit-remaining-tokens', 'x-ratelimit-reset-tokens'].each do |header|
          puts "#{header}: #{response.headers[header]}" if response.headers[header]
        end
        return "", response.code
      else
        raise "API response code: #{response.code}"
      end
    rescue Net::ReadTimeout, HTTParty::Error => e
      puts "APIリクエスト中にエラーが発生しました: #{e.message}"
      return "", response&.code || 500
    rescue StandardError => e
      puts "予期しないエラーが発生しました: #{e.message}"
      return "", response&.code || 500
    end
  end
end
