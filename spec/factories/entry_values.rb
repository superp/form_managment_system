FactoryBot.define do
  factory :entry_value do
    form_entry
    form_field
    string_value { nil }
    integer_value { nil }
    datetime_value { nil }

    trait :string do
      string_value { Faker::Lorem.sentence }
    end

    trait :integer do
      integer_value { Faker::Number.between(from: 1, to: 100) }
    end

    trait :datetime do
      datetime_value { Faker::Time.between(from: 1.year.ago, to: Time.current) }
    end
  end
end
