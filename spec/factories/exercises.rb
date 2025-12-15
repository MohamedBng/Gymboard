FactoryBot.define do
  factory :exercise do
    sequence(:title) { |n| "#{Faker::Sports::Basketball.player} #{n}" }
    association :muscle_group
  end
end
