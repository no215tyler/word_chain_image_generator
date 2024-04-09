require 'rails_helper'
require 'webmock/rspec'

describe GamesController, type: :request do
  before do
    stub_request(:post, "https://api-inference.huggingface.co/models/stablediffusionapi/breakdomainxl-v6")
    .to_return(status: 200, body: "ダミーレスポンス", headers: {})
  end

  describe "GET /games" do
    it "indexアクションにリクエストするとレスポンスが返却される" do
      get games_index_path
      expect(response.status).to eq 200
    end 
  end

  describe "POST /games" do
    it "createアクションにリクエストするとレスポンスが返却される" do
      words = ["リス", "スイカ", "カエル", "ルビー", "ビール"]
      post games_create_path, params: {words: words}
      expect(response.status).to eq 200
    end
  end
end
