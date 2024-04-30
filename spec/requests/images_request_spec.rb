require 'rails_helper'

RSpec.describe "Images", type: :request do
  before do
    @image = FactoryBot.create(:image_generate)
    sign_in @image.user
  end

  describe 'GET #gallery' do
    it 'galleryアクションへリクエストをすると正常にレスポンスが返ってくる' do
      get images_gallery_path
      expect(response.status).to eq(200)
    end
    it 'galleryアクションへリクエストするとレスポンスにしりとりの結果が存在する' do
      get images_gallery_path
      expect(response.body).to include(@image.word_chain.gsub(",", " ▷ "))
    end
    it 'galleryアクションへリクエストするとレスポンスに画像が存在する' do
      get images_gallery_path
      image_url = rails_blob_url(@image.image, only_path: true)
      expect(response.body).to include(image_url)
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get image_path(@image)
      expect(response.status).to eq(200)
    end
    it 'showアクションにリクエストするとレスポンスにしりとりの単語が含まれる' do
      get image_path(@image)
      expect(response.body).to include(@image.word_chain.gsub(",", " ▷ "))
    end
    it 'showアクションにリクエストするとレスポンスに画像が含まれる' do
      get image_path(@image)
      image_url = rails_blob_url(@image.image, only_path: true)
      expect(response.body).to include(image_url)
    end
    it 'showアクションにリクエストするとレスポンスに画像生成した作者が含まれる' do
      get image_path(@image)
      expect(response.body).to include(@image.user.name)
    end
    it 'ログイン状態でshowアクションにリクエストするとレスポンスに削除ボタンが含まれる' do
      get image_path(@image)
      expect(response.body).to include('削除')
    end
    it 'ログアウト状態でshowアクションにリクエストするとレスポンスに削除ボタンが含まれない' do
      sign_out @image.user
      get image_path(@image)
      expect(response.body).not_to include('削除')
    end
  end

  describe 'DELETE #destroy' do
    it '画像が削除される' do
      expect{delete image_path(@image), headers: { "HTTP_REFERER" => image_path(@image) }}.to change(ImageGenerate, :count).by(-1)
    end
  end
end
