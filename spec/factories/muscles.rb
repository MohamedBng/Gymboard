FactoryBot.define do
  factory :muscle do
    name { Faker::Sports::Basketball.player }
    muscle_group { Muscle.muscle_groups.keys.sample }
  end
end
