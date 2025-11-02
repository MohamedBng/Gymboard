puts "Seeding training sessions..."

# Define exercises with complete data for idempotent creation
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
    exercises: [ "Bench Press", "Push-ups", "Bicep Curls" ]
  },
  {
    name: "Evening Training",
    start_time: Time.zone.parse("2024-11-01 18:00:00"),
    end_time: Time.zone.parse("2024-11-01 19:00:00"),
    muscle_groups: [ "back", "shoulders" ],
    exercises: [ "Pull-ups", "Military Press" ]
  },
  {
    name: "Weekend Session",
    start_time: Time.zone.parse("2024-11-03 10:00:00"),
    end_time: Time.zone.parse("2024-11-03 11:00:00"),
    muscle_groups: [ "legs" ],
    exercises: [ "Squat", "Lunges", "Deadlift" ]
  },
  {
    name: nil, # Will use default name from callback
    start_time: Time.zone.parse("2024-11-02 14:00:00"),
    end_time: Time.zone.parse("2024-11-02 15:30:00"),
    muscle_groups: [ "chest", "back" ],
    exercises: [ "Bench Press", "Pull-ups" ]
  },
  {
    name: nil, # Will use default name from callback
    start_time: Time.zone.parse("2024-10-25 10:00:00"),
    end_time: Time.zone.parse("2024-10-25 12:00:00"),
    muscle_groups: [ "abs", "legs" ],
    exercises: [ "Plank", "Leg Raises", "Squat" ]
  },
  {
    name: "Strength Training",
    start_time: Time.zone.parse("2024-11-04 16:00:00"),
    end_time: Time.zone.parse("2024-11-04 17:30:00"),
    muscle_groups: [ "legs", "back", "shoulders" ],
    exercises: [ "Deadlift", "Squat", "Pull-ups", "Military Press" ]
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
      muscle_group = MuscleGroup.find_or_create_by!(name: mg_name)
      training_session_muscle_group = TrainingSessionMuscleGroup.find_or_initialize_by(
        training_session: session
      )
      training_session_muscle_group.muscle_group = muscle_group
      training_session_muscle_group.save!
    end
  end

  if data[:exercises].present?
    data[:exercises].each do |exercise_name|
      exercise_data = exercises_data[exercise_name]
      exercise = nil

      exercise_muscle_group = MuscleGroup.find_or_create_by!(name: exercise_data[:muscle_group])

      exercise = Exercise.find_or_initialize_by(title: exercise_name)
      exercise.muscle_group = exercise_muscle_group
      exercise.save!

      exercise_data[:muscles].each do |muscle_data|
        muscle_muscle_group = MuscleGroup.find_or_create_by!(name: muscle_data[:muscle_group])
        muscle = Muscle.find_or_create_by!(name: muscle_data[:name], muscle_group: muscle_muscle_group)
        exercise_muscle = ExerciseMuscle.find_or_initialize_by(
          exercise: exercise,
          muscle: muscle
        )
        exercise_muscle.role = muscle_data[:role]
        exercise_muscle.save!
      end

      if exercise
        TrainingSessionExercise.find_or_create_by!(
          training_session: session,
          exercise: exercise
        )
      end
    end
  end
end

puts "#{training_sessions_created} training sessions created"
