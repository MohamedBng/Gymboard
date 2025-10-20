FactoryBot.define do
  factory :exercise do
    title { Faker::Sports::Basketball.player }
    muscle_group { Exercise.muscle_groups.keys.sample }
  end
end
