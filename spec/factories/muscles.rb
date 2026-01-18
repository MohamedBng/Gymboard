FactoryBot.define do
  factory :muscle do
    sequence(:name) { |n| "#{Faker::Sports::Basketball.player} #{n}" }
    association :muscle_group
  end
end
