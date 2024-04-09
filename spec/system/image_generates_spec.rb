require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "画像生成の開始", type: :system do
  before do
    driven_by(:selenium_chrome) #_headless)

    stub_request(:post, "https://api-inference.huggingface.co/models/stablediffusionapi/breakdomainxl-v6")
    .to_return(status: 200, body: "ダミーレスポンス", headers: {})
  end

  context '画像生成をリクエストできる場合' do
    it '単語が5つ以上登録されていれば画像生成リクエストができる' do
      visit root_path
      fill_in 'typing-input', with: 'りす'
      click_on ('return')
      fill_in 'typing-input', with: 'スイカ'
      click_on ('return')
      fill_in 'typing-input', with: 'カエル'
      click_on ('return')
      fill_in 'typing-input', with: 'ルビー'
      click_on ('return')
      fill_in 'typing-input', with: 'ビール'
      click_on ('return')
      expect(page).to have_button('画像生成', disabled: false)
      click_on ('画像生成')
      expect(page).to have_content('画像をダウンロード', wait: 180)
      expect(ImageGenerate.count).to eq(1)
    end

    it '単語が5つ未満の場合でもゲームオーバーになれば画像生成リクエストができる' do
      visit root_path
      click_on ('R')
      click_on ('I')
      click_on ('S')
      click_on ('U')
      click_on ('return')
      click_on ('S')
      click_on ('U')
      click_on ('I')
      click_on ('K')
      click_on ('A')
      click_on ('return')
      click_on ('K')
      click_on ('A')
      click_on ('E')
      click_on ('R')
      click_on ('U')
      click_on ('return')
      click_on ('R')
      click_on ('U')
      click_on ('B')
      click_on ('I')
      click_on ('-')
      click_on ('return')
      click_on ('B')
      click_on ('I')
      click_on ('-')
      click_on ('R')
      click_on ('U')
      click_on ('return')
      expect(page).to have_button('画像生成', disabled: false)
      click_on ('画像生成')
      expect(page).to have_content('画像をダウンロード', wait: 180)
      expect(ImageGenerate.count).to eq(1)
    end
  end


  context '画像生成をリクエストできない場合' do
    it '単語が5つ未満の場合はゲームオーバーでない限り画像生成できない' do
      visit root_path
      fill_in 'typing-input', with: 'りす'
      click_on('return')
      fill_in 'typing-input', with: 'スイカ'
      click_on('return')
      fill_in 'typing-input', with: 'カエル'
      click_on('return')
      fill_in 'typing-input', with: 'ルビー'
      click_on('return')
      expect(page).to have_button('画像生成', disabled: true)
    end
  end

end
