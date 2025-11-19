puts "Seeding muscles..."

muscles = [
  { name: "Pectoralis Major", muscle_group: "chest" },
  { name: "Pectoralis Minor", muscle_group: 'chest' },
  { name: "Serratus Anterior", muscle_group: 'chest' },
  { name: "Latissimus Dorsi", muscle_group: 'back' },
  { name: "Rhomboids", muscle_group: 'back' },
  { name: "Trapezius", muscle_group: 'back' },
  { name: "Erector Spinae", muscle_group: 'back' },
  { name: "Anterior Deltoid", muscle_group: 'shoulders' },
  { name: "Medial Deltoid", muscle_group: 'shoulders' },
  { name: "Posterior Deltoid", muscle_group: 'shoulders' },
  { name: "Biceps Brachii", muscle_group: 'arm' },
  { name: "Triceps Brachii", muscle_group: 'arm' },
  { name: "Forearms", muscle_group: 'arm' },
  { name: "Quadriceps", muscle_group: 'legs' },
  { name: "Hamstrings", muscle_group: 'legs' },
  { name: "Glutes", muscle_group: 'legs' },
  { name: "Calves", muscle_group: 'legs' },
  { name: "Rectus Abdominis", muscle_group: 'abs' },
  { name: "Obliques", muscle_group: 'abs' },
  { name: "Transverse Abdominis", muscle_group: 'abs' }
]
muscles_created = 0
muscles.each do |data|
    muscle = Muscle.find_or_initialize_by(name: data[:name])
    muscle.muscle_group = MuscleGroup.find_or_create_by!(name: data[:muscle_group])
    muscle.save!
    muscles_created += 1 if muscle.previously_new_record?
end

puts "#{muscles_created} muscles created"
