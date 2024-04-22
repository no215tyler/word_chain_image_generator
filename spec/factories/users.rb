FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
    email { Faker::Internet.email }
    password { '1a' + Faker::Internet.password(min_length: 7, max_length: 20) }
    password_confirmation { password }
  end
end
