FactoryBot.define do
  factory :muscle_group do
    name { [ "chest", "back", "shoulders", "arm", "legs", "abs" ].sample }
  end
end
