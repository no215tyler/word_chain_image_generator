Rails.application.config.to_prepare do
  $twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['X_CONSUMER_KEY']
    config.consumer_secret     = ENV['X_CONSUMER_SECRET']
    config.access_token        = ENV['X_ACCESS_TOKEN']
    config.access_token_secret = ENV['X_ACCESS_TOKEN_SECRET']
  end
end
