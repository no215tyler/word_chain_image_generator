require 'httparty'

class TranslationService
  API_URL = "https://script.google.com/macros/s/AKfycby3j14ndj7K1O60GS-aIaoRwzEHQpcsbZbni9t4t2IUHQ8IR51aExtqEMHt81sVqUI8pQ/exec"
  
  def self.translate(words)
    query = { text: words, source: 'ja', target: 'en' }
    response = HTTParty.get(API_URL, query: query)
    if response.success?
      response.parsed_response["text"]
    else
      words # 翻訳に失敗した場合は元のテキストを返す
    end
  end
end
