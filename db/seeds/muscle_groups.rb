puts "Seeding muscle groups..."
muscle_group_names = %w[chest back shoulders arm legs abs]

muscle_groups_created = 0
muscle_group_names.each do |name|
  muscle_group = MuscleGroup.find_or_create_by!(name: name)
  muscle_group.save!
  muscle_groups_created += 1 if muscle_group.persisted?
end

puts "#{muscle_groups_created} muscle groups created"
