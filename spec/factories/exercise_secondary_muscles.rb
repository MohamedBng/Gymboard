FactoryBot.define do
  factory :exercise_secondary_muscle do
    association :exercise
    association :muscle
  end
end
