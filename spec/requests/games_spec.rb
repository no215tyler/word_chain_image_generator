require 'rails_helper'
require 'webmock/rspec'

describe GamesController, type: :request do
  before do
    @user = FactoryBot.create(:user)
    sign_in @user
    stub_request(:post, 'https://api-inference.huggingface.co/models/stablediffusionapi/breakdomainxl-v6')
      .to_return(status: 200, body: 'ダミーレスポンス', headers: {})
  end

  describe 'GET /games' do
    it 'indexアクションにリクエストするとレスポンスが返却される' do
      get games_index_path
      expect(response.status).to eq 200
    end
  end

  describe 'POST /games' do
    it 'createアクションにリクエストするとレスポンスが返却される' do
      words = %W[\u30EA\u30B9 \u30B9\u30A4\u30AB \u30AB\u30A8\u30EB \u30EB\u30D3\u30FC \u30D3\u30FC\u30EB]
      post games_create_path, params: { words:, user_id: @user.id }
      expect(response.status).to eq 200
    end
  end
end
