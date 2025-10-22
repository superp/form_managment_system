FactoryBot.define do
  factory :form do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    user
  end
end
