puts "Seeding training sessions..."

training_sessions = [
  {
    name: "Morning Workout",
    start_time: Time.current.beginning_of_day + 8.hours,
    end_time: Time.current.beginning_of_day + 9.hours,
    muscle_groups: [ "chest", "arm" ]
  },
  {
    name: "Evening Training",
    start_time: Time.current.beginning_of_day + 18.hours,
    end_time: Time.current.beginning_of_day + 19.hours,
    muscle_groups: [ "back", "shoulders" ]
  },
  {
    name: "Weekend Session",
    start_time: (Time.current + 2.days).beginning_of_day + 10.hours,
    end_time: (Time.current + 2.days).beginning_of_day + 11.hours,
    muscle_groups: [ "legs" ]
  },
  {
    name: nil, # Will use default name from callback
    start_time: Time.current + 1.day,
    end_time: Time.current + 1.day + 1.5.hours,
    muscle_groups: [ "chest", "back" ]
  },
  {
    name: nil, # Will use default name from callback
    start_time: Time.current - 1.week,
    end_time: Time.current - 1.week + 2.hours,
    muscle_groups: [ "abs", "legs" ]
  },
  {
    name: "Strength Training",
    start_time: Time.current + 3.days,
    end_time: Time.current + 3.days + 1.5.hours,
    muscle_groups: [ "legs", "back", "shoulders" ]
  }
]

training_sessions_created = 0
training_sessions.each do |data|
  session = TrainingSession.find_or_initialize_by(
    start_time: data[:start_time],
    end_time: data[:end_time]
  )

  session.name = data[:name] if data[:name].present?

  if session.new_record? || session.changed?
    session.save!
    training_sessions_created += 1 if session.previously_new_record?
  end

  if data[:muscle_groups].present?
    data[:muscle_groups].each do |mg_name|
      muscle_group = MuscleGroup.find_by!(name: mg_name)
      training_session_muscle_group = TrainingSessionMuscleGroup.find_or_create_by!(
        training_session: session,
      )
      training_session_muscle_group.muscle_group = muscle_group
      training_session_muscle_group.save!
    end
  end
end

puts "#{training_sessions_created} training sessions created"
