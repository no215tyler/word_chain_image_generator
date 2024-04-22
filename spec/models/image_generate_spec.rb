require 'rails_helper'

RSpec.describe ImageGenerate, type: :model do

  before do
    user = FactoryBot.create(:user)
    @result_generate = FactoryBot.build(:image_generate)
  end

  describe '画像生成結果の保存' do
    context '画像生成結果を保存できる' do
      it 'しりとりの単語と、プロンプトがあり、HTTPステータスがレスポンスされていれば画像生成に使用されたデータが保存される' do
        expect(@result_generate).to be_valid
      end
    end


    context '画像生成結果を保存できない' do
      it 'しりとりの単語がひとつも登録されていない場合は保存できない' do
        @result_generate.word_chain = ""
        @result_generate.valid?
        expect(@result_generate.errors.full_messages).to include("Word chain can't be blank")
      end
      it 'プロンプトが空だと保存できない' do
        @result_generate.prompt = ""
        @result_generate.valid?
        expect(@result_generate.errors.full_messages).to include("Prompt can't be blank")
      end
      it 'HTTPステータスが空だと保存できない' do
        @result_generate.http_status = nil
        @result_generate.valid?
        expect(@result_generate.errors.full_messages).to include("Http status can't be blank")
      end
    end
  end
end
