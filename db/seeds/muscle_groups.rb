# Seed muscle groups (idempotent)
muscle_group_names = %w[chest back shoulders arm legs abs]

muscle_group_names.each do |name|
  MuscleGroup.find_or_create_by!(name: name)
end
