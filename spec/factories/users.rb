FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    uid { SecureRandom.uuid }

    trait :invalid do
      name { nil }
      email { nil }
      password { nil }
    end
  end
end
