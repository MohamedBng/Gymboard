FactoryBot.define do
  factory :exercise_muscle do
    association :exercise
    association :muscle
  end
end
