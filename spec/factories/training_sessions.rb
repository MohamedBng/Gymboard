FactoryBot.define do
  factory :training_session do
    name { Faker::Lorem.words(number: 2).join(" ") }
    start_time { Faker::Time.between(from: 1.month.ago, to: 1.month.from_now) }
    end_time { start_time&.+(rand(1..4).hours) }
  end
end
