require 'httparty'

class TinyUrlService
  API_ENDPOINT = "http://tinyurl.com/api-create.php"

  def self.shorten(url)
    response = HTTParty.get("#{API_ENDPOINT}?url=#{url}")
    if response.code == 200
      response.body
    else
      url  # HTTPステータスコードが200以外の場合は元のURLを返す
    end
  rescue HTTParty::Error, SocketError => e
    Rails.logger.error "TinyURL API call failed: #{e.message}"
    url  # 例外が発生した場合も元のURLを返す
  end
end
