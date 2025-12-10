puts "Seeding exercises..."

exercises = [
  {
    title: "Bench Press",
    muscle_group: "chest",
    muscles: [
      { name: "Pectoralis Major", muscle_group: "chest", role: "primary" },
      { name: "Anterior Deltoid", muscle_group: "shoulders", role: "secondary" },
      { name: "Triceps Brachii", muscle_group: "arm", role: "secondary" }
    ]
  },
  {
    title: "Squat",
    muscle_group: "legs",
    muscles: [
      { name: "Quadriceps", muscle_group: "legs", role: "primary" },
      { name: "Glutes", muscle_group: "legs", role: "primary" },
      { name: "Rectus Abdominis", muscle_group: "abs", role: "secondary" }
    ]
  },
  {
    title: "Deadlift",
    muscle_group: "legs",
    muscles: [
      { name: "Hamstrings", muscle_group: "legs", role: "primary" },
      { name: "Glutes", muscle_group: "legs", role: "primary" },
      { name: "Erector Spinae", muscle_group: "back", role: "primary" },
      { name: "Trapezius", muscle_group: "back", role: "secondary" }
    ]
  },
  {
    title: "Military Press",
    muscle_group: "shoulders",
    muscles: [
      { name: "Anterior Deltoid", muscle_group: "shoulders", role: "primary" },
      { name: "Medial Deltoid", muscle_group: "shoulders", role: "primary" },
      { name: "Triceps Brachii", muscle_group: "arm", role: "secondary" }
    ]
  },
  {
    title: "Pull-ups",
    muscle_group: "back",
    muscles: [
      { name: "Latissimus Dorsi", muscle_group: "back", role: "primary" },
      { name: "Rhomboids", muscle_group: "back", role: "primary" },
      { name: "Biceps Brachii", muscle_group: "arm", role: "secondary" }
    ]
  },
  {
    title: "Push-ups",
    muscle_group: "chest",
    muscles: [
      { name: "Pectoralis Major", muscle_group: "chest", role: "primary" },
      { name: "Anterior Deltoid", muscle_group: "shoulders", role: "secondary" },
      { name: "Triceps Brachii", muscle_group: "arm", role: "secondary" },
      { name: "Rectus Abdominis", muscle_group: "abs", role: "secondary" }
    ]
  },
  {
    title: "Plank",
    muscle_group: "abs",
    muscles: [
      { name: "Rectus Abdominis", muscle_group: "abs", role: "primary" },
      { name: "Obliques", muscle_group: "abs", role: "primary" },
      { name: "Transverse Abdominis", muscle_group: "abs", role: "primary" },
      { name: "Anterior Deltoid", muscle_group: "shoulders", role: "secondary" }
    ]
  },
  {
    title: "Lunges",
    muscle_group: "legs",
    muscles: [
      { name: "Quadriceps", muscle_group: "legs", role: "primary" },
      { name: "Glutes", muscle_group: "legs", role: "primary" },
      { name: "Hamstrings", muscle_group: "legs", role: "secondary" }
    ]
  },
  {
    title: "Bicep Curls",
    muscle_group: "arm",
    muscles: [
      { name: "Biceps Brachii", muscle_group: "arm", role: "primary" },
      { name: "Forearms", muscle_group: "arm", role: "secondary" }
    ]
  },
  {
    title: "Tricep Extensions",
    muscle_group: "arm",
    muscles: [
      { name: "Triceps Brachii", muscle_group: "arm", role: "primary" },
      { name: "Forearms", muscle_group: "arm", role: "secondary" }
    ]
  },
  {
    title: "Leg Raises",
    muscle_group: "abs",
    muscles: [
      { name: "Rectus Abdominis", muscle_group: "abs", role: "primary" },
      { name: "Obliques", muscle_group: "abs", role: "secondary" }
    ]
  }
]


exercises_created = 0
exercises.each do |data|
  exercise_muscle_group = MuscleGroup.find_or_create_by!(name: data[:muscle_group])
  exercise = Exercise.find_or_initialize_by(title: data[:title])
  exercise.muscle_group = exercise_muscle_group
  exercise.save!


  data[:muscles].each do |muscle_data|
    muscle_muscle_group = MuscleGroup.find_or_create_by!(name: muscle_data[:muscle_group])
    muscle = Muscle.find_or_create_by!(name: muscle_data[:name], muscle_group: muscle_muscle_group)
    exercise_muscle = ExerciseMuscle.find_or_initialize_by(
      exercise: exercise,
      muscle: muscle
    )
    exercise_muscle.role = muscle_data[:role]

    exercise.save!
    exercises_created += 1 if exercise.previously_new_record?
  end
end

puts "#{exercises_created} exercises created"
