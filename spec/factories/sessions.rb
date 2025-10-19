FactoryBot.define do
  factory :session do
    start_time { Faker::Time.between(from: 1.day.ago, to: 1.day.from_now) }
    end_time { start_time + rand(1..4).hours }
    title { Faker::Sports::Basketball.team }
  end
end
