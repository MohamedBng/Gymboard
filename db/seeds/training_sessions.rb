puts "Seeding training sessions..."

users_data = [
  {
    email: "alice@example.com",
    first_name: "Alice",
    last_name: "Martin"
  },
  {
    email: "bob@example.com",
    first_name: "Bob",
    last_name: "Dupont"
  },
  {
    email: "charlie@example.com",
    first_name: "Charlie",
    last_name: "Bernard"
  },
  {
    email: "diana@example.com",
    first_name: "Diana",
    last_name: "Moreau"
  }
]

users = []
users_data.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.first_name = user_data[:first_name]
    u.last_name = user_data[:last_name]
    u.password = "password123"
    u.password_confirmation = "password123"
    u.confirmed_at = Time.current
  end

  user.roles << Role.find_or_create_by!(name: "user") if user.roles.empty?
  users << user
end

exercises_data = {
  "Bench Press" => {
    muscle_group: "chest",
    muscles: [
      { name: "Pectoralis Major", muscle_group: "chest", role: "primary" },
      { name: "Anterior Deltoid", muscle_group: "shoulders", role: "secondary" },
      { name: "Triceps Brachii", muscle_group: "arm", role: "secondary" }
    ]
  },
  "Push-ups" => {
    muscle_group: "chest",
    muscles: [
      { name: "Pectoralis Major", muscle_group: "chest", role: "primary" },
      { name: "Anterior Deltoid", muscle_group: "shoulders", role: "secondary" },
      { name: "Triceps Brachii", muscle_group: "arm", role: "secondary" },
      { name: "Rectus Abdominis", muscle_group: "abs", role: "secondary" }
    ]
  },
  "Bicep Curls" => {
    muscle_group: "arm",
    muscles: [
      { name: "Biceps Brachii", muscle_group: "arm", role: "primary" },
      { name: "Forearms", muscle_group: "arm", role: "secondary" }
    ]
  },
  "Pull-ups" => {
    muscle_group: "back",
    muscles: [
      { name: "Latissimus Dorsi", muscle_group: "back", role: "primary" },
      { name: "Rhomboids", muscle_group: "back", role: "primary" },
      { name: "Biceps Brachii", muscle_group: "arm", role: "secondary" }
    ]
  },
  "Military Press" => {
    muscle_group: "shoulders",
    muscles: [
      { name: "Anterior Deltoid", muscle_group: "shoulders", role: "primary" },
      { name: "Medial Deltoid", muscle_group: "shoulders", role: "primary" },
      { name: "Triceps Brachii", muscle_group: "arm", role: "secondary" }
    ]
  },
  "Squat" => {
    muscle_group: "legs",
    muscles: [
      { name: "Quadriceps", muscle_group: "legs", role: "primary" },
      { name: "Glutes", muscle_group: "legs", role: "primary" },
      { name: "Rectus Abdominis", muscle_group: "abs", role: "secondary" }
    ]
  },
  "Lunges" => {
    muscle_group: "legs",
    muscles: [
      { name: "Quadriceps", muscle_group: "legs", role: "primary" },
      { name: "Glutes", muscle_group: "legs", role: "primary" },
      { name: "Hamstrings", muscle_group: "legs", role: "secondary" }
    ]
  },
  "Deadlift" => {
    muscle_group: "legs",
    muscles: [
      { name: "Hamstrings", muscle_group: "legs", role: "primary" },
      { name: "Glutes", muscle_group: "legs", role: "primary" },
      { name: "Erector Spinae", muscle_group: "back", role: "primary" },
      { name: "Trapezius", muscle_group: "back", role: "secondary" }
    ]
  },
  "Plank" => {
    muscle_group: "abs",
    muscles: [
      { name: "Rectus Abdominis", muscle_group: "abs", role: "primary" },
      { name: "Obliques", muscle_group: "abs", role: "primary" },
      { name: "Transverse Abdominis", muscle_group: "abs", role: "primary" },
      { name: "Anterior Deltoid", muscle_group: "shoulders", role: "secondary" }
    ]
  },
  "Leg Raises" => {
    muscle_group: "abs",
    muscles: [
      { name: "Rectus Abdominis", muscle_group: "abs", role: "primary" },
      { name: "Obliques", muscle_group: "abs", role: "secondary" }
    ]
  }
}

training_sessions = [
  {
    name: "Morning Workout",
    start_time: Time.zone.parse("2024-11-01 08:00:00"),
    end_time: Time.zone.parse("2024-11-01 09:00:00"),
    muscle_groups: [ "chest", "arm" ],
    exercises: {
      "Bench Press" => [
        { reps: 12, weight: 60000, rest: 45 },
        { reps: 10, weight: 65000, rest: 60 },
        { reps: 8, weight: 70000, rest: 75 }
      ],
      "Push-ups" => [
        { reps: 15, weight: 0, rest: 45 },
        { reps: 12, weight: 0, rest: 60 },
        { reps: 10, weight: 0, rest: 75 }
      ],
      "Bicep Curls" => [
        { reps: 12, weight: 25000, rest: 45 },
        { reps: 10, weight: 25000, rest: 45 },
        { reps: 8, weight: 25000, rest: 45 }
      ]
    }
  },
  {
    name: "Evening Training",
    start_time: Time.zone.parse("2024-11-01 18:00:00"),
    end_time: Time.zone.parse("2024-11-01 19:00:00"),
    muscle_groups: [ "back", "shoulders" ],
    exercises: {
      "Pull-ups" => [
        { reps: 10, weight: 0, rest: 60 },
        { reps: 8, weight: 0, rest: 75 },
        { reps: 6, weight: 0, rest: 90 }
      ],
      "Military Press" => [
        { reps: 10, weight: 50000, rest: 60 },
        { reps: 8, weight: 55000, rest: 75 },
        { reps: 6, weight: 60000, rest: 90 }
      ]
    }
  },
  {
    name: "Weekend Session",
    start_time: Time.zone.parse("2024-11-03 10:00:00"),
    end_time: Time.zone.parse("2024-11-03 11:00:00"),
    muscle_groups: [ "legs" ],
    exercises: {
      "Squat" => [
        { reps: 10, weight: 80000, rest: 90 },
        { reps: 8, weight: 85000, rest: 90 },
        { reps: 6, weight: 90000, rest: 120 }
      ],
      "Lunges" => [
        { reps: 12, weight: 40000, rest: 60 },
        { reps: 10, weight: 40000, rest: 60 },
        { reps: 8, weight: 40000, rest: 60 }
      ],
      "Deadlift" => [
        { reps: 8, weight: 90000, rest: 120 },
        { reps: 6, weight: 95000, rest: 120 },
        { reps: 5, weight: 100000, rest: 120 }
      ]
    }
  },
  {
    name: nil, # Will use default name from callback
    start_time: Time.zone.parse("2024-11-02 14:00:00"),
    end_time: Time.zone.parse("2024-11-02 15:30:00"),
    muscle_groups: [ "chest", "back" ],
    exercises: {
      "Bench Press" => [
        { reps: 10, weight: 65000, rest: 60 },
        { reps: 8, weight: 70000, rest: 75 },
        { reps: 6, weight: 75000, rest: 90 }
      ],
      "Pull-ups" => [
        { reps: 12, weight: 0, rest: 60 },
        { reps: 10, weight: 0, rest: 75 },
        { reps: 8, weight: 0, rest: 90 },
        { reps: 6, weight: 0, rest: 90 }
      ]
    }
  },
  {
    name: nil, # Will use default name from callback
    start_time: Time.zone.parse("2024-10-25 10:00:00"),
    end_time: Time.zone.parse("2024-10-25 12:00:00"),
    muscle_groups: [ "abs", "legs" ],
    exercises: {
      "Plank" => [
        { reps: 1, weight: 0, rest: 60 },
        { reps: 1, weight: 0, rest: 60 },
        { reps: 1, weight: 0, rest: 60 }
      ],
      "Leg Raises" => [
        { reps: 15, weight: 0, rest: 45 },
        { reps: 12, weight: 0, rest: 45 },
        { reps: 10, weight: 0, rest: 45 }
      ],
      "Squat" => [
        { reps: 12, weight: 70000, rest: 90 },
        { reps: 10, weight: 75000, rest: 90 },
        { reps: 8, weight: 80000, rest: 120 }
      ]
    }
  },
  {
    name: "Strength Training",
    start_time: Time.zone.parse("2024-11-04 16:00:00"),
    end_time: Time.zone.parse("2024-11-04 17:30:00"),
    muscle_groups: [ "legs", "back", "shoulders" ],
    exercises: {
      "Deadlift" => [
        { reps: 5, weight: 100000, rest: 180 },
        { reps: 3, weight: 110000, rest: 180 },
        { reps: 1, weight: 120000, rest: 240 }
      ],
      "Squat" => [
        { reps: 8, weight: 85000, rest: 120 },
        { reps: 6, weight: 90000, rest: 120 },
        { reps: 5, weight: 95000, rest: 150 }
      ],
      "Pull-ups" => [
        { reps: 10, weight: 0, rest: 90 },
        { reps: 8, weight: 0, rest: 90 },
        { reps: 6, weight: 0, rest: 120 }
      ],
      "Military Press" => [
        { reps: 8, weight: 55000, rest: 90 },
        { reps: 6, weight: 60000, rest: 90 },
        { reps: 5, weight: 65000, rest: 120 }
      ]
    }
  }
]

training_sessions_created = 0
training_sessions.each_with_index do |data, index|
  # Distribute sessions across users in a round-robin fashion
  user = users[index % users.length]

  session = TrainingSession.find_or_initialize_by(
    start_time: data[:start_time],
    end_time: data[:end_time],
    user: user
  )

  session.user = user
  session.name = data[:name] if data[:name].present?

  if session.new_record? || session.changed?
    session.save!
    training_sessions_created += 1 if session.previously_new_record?
  end

  if data[:muscle_groups].present?
    data[:muscle_groups].each do |mg_name|
      muscle_group = MuscleGroup.find_or_create_by!(name: mg_name)
      training_session_muscle_group = TrainingSessionMuscleGroup.find_or_initialize_by(
        training_session: session
      )
      training_session_muscle_group.muscle_group = muscle_group
      training_session_muscle_group.save!
    end
  end

  if data[:exercises].present?
    data[:exercises].each do |exercise_name, exercise_sets|
      exercise_data = exercises_data[exercise_name]
      next unless exercise_data

      exercise_muscle_group = MuscleGroup.find_or_create_by!(name: exercise_data[:muscle_group])

      exercise = Exercise.find_or_initialize_by(title: exercise_name)
      exercise.muscle_group = exercise_muscle_group
      exercise.save!

      exercise_data[:muscles].each do |muscle_data|
        muscle_muscle_group = MuscleGroup.find_or_create_by!(name: muscle_data[:muscle_group])
        muscle = Muscle.find_or_create_by!(name: muscle_data[:name], muscle_group: muscle_muscle_group)
        exercise_muscle = ExerciseSecondaryMuscle.find_or_initialize_by(
          exercise: exercise,
          muscle: muscle
        )
        exercise_muscle.role = muscle_data[:role]
        exercise_muscle.save!
      end

      training_session_exercise = TrainingSessionExercise.find_or_create_by!(
        training_session: session,
        exercise: exercise
      )

      if exercise_sets.is_a?(Array) && exercise_sets.any?
        exercise_sets.each do |set_data|
          ExerciseSet.find_or_create_by!(
            training_session_exercise: training_session_exercise,
            reps: set_data[:reps],
            weight: set_data[:weight],
            rest: set_data[:rest]
          )
        end
      end
    end
  end
end

puts "#{training_sessions_created} training sessions created"
