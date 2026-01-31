FactoryBot.define do
  factory :exercise do
    sequence(:title) { |n| "#{Faker::Sports::Basketball.player} #{n}" }
    association :muscle_group
    association :primary_muscle, factory: :muscle

    trait :with_secondary_muscles do
      after(:create) do |exercise|
        exercise.secondary_muscles << create_list(:muscle, 2)
      end
    end
  end
end
