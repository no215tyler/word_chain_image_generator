require 'httparty'

class WordFilterService
  def self.filter_words(words)
    uri = 'https://script.google.com/macros/s/AKfycbx0jq_mggzk6vILUUWLIDGpvl_Gi5iIZtzTh4JoA58yDAh7N5HyQVocfp7nzaMRnMigWw/exec'
    query = { words: words.join(',') }
    response = HTTParty.get(uri, query:, follow_redirects: true)

    if response.success?
      JSON.parse(response.body)['filteredWords']
    else
      puts "HTTP Error: #{response.code} #{response.message}"
      words # エラーの場合は入力された単語リストをそのまま返す
    end
  rescue StandardError => e
    puts "Error filtering words: #{e.message}"
    words # 通信エラーの場合も入力された単語リストをそのまま返す
  end
end
