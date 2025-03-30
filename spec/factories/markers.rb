FactoryBot.define do
  factory :marker do
    location { "POINT(139.764936 35.681236)" }
    order { 0 }
    association :course
  end
end
