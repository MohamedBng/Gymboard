FactoryBot.define do
  factory :exercise do
    title { Faker::Sports::Basketball.player }
    association :muscle_group
  end
end
