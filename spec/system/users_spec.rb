require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
    driven_by(:selenium_chrome_headless)
  end

  context '新規登録できる場合' do
    it '入力事項を正しく入力すればユーザー新規登録ができ、トップページに遷移する' do
      # トップページに移動する
      visit root_path
      # 遊び方モーダルを閉じハンバーガーメニューを表示する
      find('#close-how-to-play-icon').click
      find('#js-hamburger').click

      # 新規登録ページへのリンクがあることを確認する
      expect(page).to have_content('新規登録')

      # 新規登録ページへ遷移する
      visit new_user_registration_path

      # ユーザー情報を入力する
      fill_in 'user_name', with: @user.name
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation

      # サインアップボタンをクリックするとユーザーモデルのカウントが1上昇する
      expect do
        click_on('サインアップ')
        sleep 1
      end.to change { User.count }.by(1)
      # トップページへ遷移することを確認する
      expect(page).to have_current_path(root_path)

      # ハンバーガーメニューを表示しログアウトリンクが表示されることを確認する
      find('#js-hamburger').click
      expect(page).to have_content('ログアウト')

      # 新規登録ページやログインページへのリンクが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context '新規登録できない場合' do
    it '誤った情報ではユーザー新規登録できず、新規登録ページへ戻ってくる' do
      # トップページへ移動する
      visit root_path

      # 遊び方モーダルを閉じハンバーガーメニューを表示する
      find('#close-how-to-play-icon').click
      find('#js-hamburger').click

      # 新規登録ページへのリンクがあることを確認する
      expect(page).to have_content('新規登録')

      # 新規登録ページへ遷移する
      visit new_user_registration_path

      # ユーザー情報を入力する
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''

      # サインアップボタンをクリックいてもユーザーモデルのカウントが上昇しないことを確認する
      expect do
        click_on('サインアップ')
        sleep 1
      end.to change { User.count }.by(0)

      # 新規登録ページへ戻されることを確認する
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end

RSpec.describe 'ユーザーログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
    driven_by(:selenium_chrome_headless)
  end

  context 'ログインできる場合' do
    it '保存されているユーザーの情報と合致すればログインできる' do
      # トップページへ移動する
      visit root_path

      # 遊び方モーダルを閉じハンバーガーメニューを開く
      find('#close-how-to-play-icon').click
      find('#js-hamburger').click

      # ログインページへ遷移するリンクがあることを確認する
      expect(page).to have_content('ログイン')

      # ログインページへ遷移する
      visit new_user_session_path

      # 正しいユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password

      # ログインボタンをクリックする
      click_on('ログイン')

      # トップページへ遷移することを確認する
      expect(page).to have_current_path(root_path)

      # ハンバーガーメニューを開くとログアウトのリンクが表示されることを確認する
      find('#js-hamburger').click
      expect(page).to have_content('ログアウト')

      # サインアップページやログインページへ遷移するリンクが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ログインできない場合' do
    it '保存されているユーザーの情報と合致しないとログインできない' do
      # トップページへ移動する
      visit root_path

      # 遊び方モーダルを閉じハンバーガーメニューを開く
      find('#close-how-to-play-icon').click
      find('#js-hamburger').click

      # ログインページへ遷移するリンクがあることを確認する
      expect(page).to have_content('ログイン')

      # ログインページへ遷移する
      visit new_user_session_path

      # ユーザー情報入力フィールドに正しい情報が入力されない
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''

      # ログインボタンをクリックする
      click_on('ログイン')

      # ログインページへ戻されることを確認する
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
