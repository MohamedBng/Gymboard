FactoryBot.define do
  factory :exercise do
    sequence(:title) { |n| "#{Faker::Sports::Basketball.player} #{n}" }
    association :muscle_group
    primary_muscle {association(:muscle)}
  end
end
