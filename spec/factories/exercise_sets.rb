FactoryBot.define do
  factory :exercise_set do
    association :training_session_exercise
    reps { rand(6..12) }
    weight { rand(20000..100000) }
    rest { rand(30..120) }
  end
end
