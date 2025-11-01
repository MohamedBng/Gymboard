FactoryBot.define do
  factory :muscle do
    name { Faker::Sports::Basketball.player }
    association :muscle_group
  end
end
