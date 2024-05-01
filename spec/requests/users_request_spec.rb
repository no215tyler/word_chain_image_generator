require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do 
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  describe "GET #show" do
    it "showアクションにリクエストを送ると正常にレスポンスが返ってくる" do
      get user_path(@user)
      expect(response.status).to eq(200)
    end
    it "showアクションにリクエストを送るとレスポンスにユーザー名が含まれる" do
      get user_path(@user)
      expect(response.body).to include(@user.name)
    end
  end

end
