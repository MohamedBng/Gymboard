FactoryBot.define do
  factory :exercise_muscle do
    association :exercise
    association :muscle
    role { ExerciseMuscle.roles.keys.sample }
  end
end
