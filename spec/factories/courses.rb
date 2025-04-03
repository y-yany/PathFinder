FactoryBot.define do
  factory :course do
    sequence(:title) { |n| "title#{n} "}
    sequence(:body) { |n| "body#{n} "}
    distance { Random.rand(999.99).floor(2) }
    address { "address" }
    encoded_polyline { "encoded_polyline_string" }
    association :user

    trait :invalid do
      title { "" }
      encoded_polyline { "" }
    end

    trait :show do
      title { "Show" }
    end
  end
end
