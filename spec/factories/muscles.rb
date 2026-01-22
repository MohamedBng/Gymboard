FactoryBot.define do
  factory :muscle do
    sequence(:name) { |n| "muscle-#{n}" }
    association :muscle_group
  end
end
