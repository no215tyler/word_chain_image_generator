FactoryBot.define do
  factory :image_generate do
    word_chain {'リス, スイカ, カエル, ルビー, ビール'}
    prompt {'squirrel, water melon, flog, ruby, beer'}
    http_status { 200 }
    association :user
  end
end
