FactoryBot.define do
  factory :field do
    name { Faker::Lorem.word }
    field_type { 'string' }
    min_length { nil }
    max_length { nil }
    min_value { nil }
    max_value { nil }
    user

    trait :string do
      field_type { 'string' }
      min_length { 1 }
      max_length { 100 }
    end

    trait :integer do
      field_type { 'integer' }
      min_value { 0 }
      max_value { 1000 }
    end

    trait :datetime do
      field_type { 'datetime' }
    end
  end
end
