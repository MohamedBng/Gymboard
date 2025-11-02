FactoryBot.define do
  factory :training_session_exercise do
    association :training_session
    association :exercise
  end
end
