require 'rails_helper'

RSpec.describe "しりとりルール", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'しりとりが続けられる場合' do
    it '単語が拗音で終わる場合は次の単語の頭文字も拗音で開始する' do
      visit root_path
      find('#close-how-to-play-icon').click
      fill_in 'typing-input', with: 'かいしゃ'
      click_on('return')
      fill_in 'typing-input', with: 'あ'
      click_on('return')
      expect(page).to have_content('「しゃ」')
      sleep 2
      fill_in 'typing-input', with: 'しゃかい'
      click_on('return')
      expect(page).to have_no_content('「しゃ」')
    end

    it '単語が長音記号で終わる場合は次の単語の頭文字は長音記号の前の文字列で開始する' do
      visit root_path
      find('#close-how-to-play-icon').click
      fill_in 'typing-input', with: 'ヒーロー'
      click_on('return')
      fill_in 'typing-input', with: 'あ'
      click_on('return')
      expect(page).to have_content('「ろ」')
      sleep 2
      fill_in 'typing-input', with: 'ろうそく'
      click_on('return')
      expect(page).to have_no_content('「ろ」')
    end

    it '単語が拗音＋長音で終わる場合は次の単語の頭文字は拗音で開始する' do
      visit root_path
      find('#close-how-to-play-icon').click
      fill_in 'typing-input', with: 'イルカショー'
      click_on('return')
      fill_in 'typing-input', with: 'あ'
      click_on('return')
      expect(page).to have_content('「しょ」')
      sleep 2
      fill_in 'typing-input', with: 'ショータイム'
      click_on('return')
      expect(page).to have_no_content('「しょ」')
    end
  end

  context 'しりとりが続けられない場合' do
    it '単語が「ん」で終わるとゲームオーバーになる' do
      visit root_path
      find('#close-how-to-play-icon').click
      fill_in 'typing-input', with: 'あかちゃん'
      click_on('return')
      expect(page).to have_content('ゲーム終了')
    end
  end
end
