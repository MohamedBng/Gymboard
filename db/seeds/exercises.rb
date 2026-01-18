puts "Seeding exercises..."

exercises_file_path = Rails.root.join('db/seeds/data/exercises.json')
exercises = JSON.parse(File.read(exercises_file_path))

exercises_created = 0
exercises.each do |data|
  exercise_muscle_group = MuscleGroup.find_or_create_by!(name: data["muscle_group"])
  exercise = Exercise.find_or_initialize_by(title: data["title"])
  exercise.muscle_group = exercise_muscle_group
  exercise.verified_at = DateTime.now
  exercise.save!
  exercises_created += 1 if exercise.previously_new_record?


  data["muscles"].each do |muscle_data|
    muscle_muscle_group = MuscleGroup.find_or_create_by!(name: muscle_data["muscle_group"])

    muscle = Muscle.find_or_initialize_by(name: muscle_data["name"])
    muscle.muscle_group = muscle_muscle_group
    muscle.save!

    exercise_muscle = ExerciseMuscle.find_or_initialize_by(
      exercise: exercise,
      muscle: muscle
    )

    exercise_muscle.role = muscle_data["role"]

    exercise_muscle.save!
  end
  print "."
end

puts "#{exercises_created} exercises created"
