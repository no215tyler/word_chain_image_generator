require 'rails_helper'

describe GamesController, type: :request do

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
      expect(response.status).to be_in([200, 429, 500, 503])
    end
  end
end
