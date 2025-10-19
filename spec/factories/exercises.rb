FactoryBot.define do
  factory :exercise do
    title { Faker::Sports::Basketball.player }
  end
end
