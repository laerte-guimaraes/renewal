FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.free_email(name: name) }
    password { 'pswd.123' }
    association :contract
  end
end
