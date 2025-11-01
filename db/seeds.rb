# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create roles with color
roles_with_colors = {
  "admin" => "#DC3545",
  "user"  => "#17A2B8"
}

roles_with_colors.each do |role_name, color|
  role = Role.find_or_create_by!(name: role_name)
  role.update!(color: color)
end

# Seed muscle group
load Rails.root.join('db', 'seeds', 'muscle_groups.rb')

# Seed muscles
load Rails.root.join('db', 'seeds', 'muscles.rb')


# Seed exercises with muscle associations (idempotent)
exercise_seeds = [
  {
    title: "Bench Press",
    muscle_group: :chest,
    muscles: [
      { name: "Pectoralis Major", role: :primary },
      { name: "Anterior Deltoid", role: :secondary },
      { name: "Triceps Brachii", role: :secondary }
    ]
  },
  {
    title: "Squat",
    muscle_group: :legs,
    muscles: [
      { name: "Quadriceps", role: :primary },
      { name: "Glutes", role: :primary },
      { name: "Rectus Abdominis", role: :secondary }
    ]
  },
  {
    title: "Deadlift",
    muscle_group: :legs,
    muscles: [
      { name: "Hamstrings", role: :primary },
      { name: "Glutes", role: :primary },
      { name: "Erector Spinae", role: :primary },
      { name: "Trapezius", role: :secondary }
    ]
  },
  {
    title: "Military Press",
    muscle_group: :shoulders,
    muscles: [
      { name: "Anterior Deltoid", role: :primary },
      { name: "Medial Deltoid", role: :primary },
      { name: "Triceps Brachii", role: :secondary }
    ]
  },
  {
    title: "Pull-ups",
    muscle_group: :back,
    muscles: [
      { name: "Latissimus Dorsi", role: :primary },
      { name: "Rhomboids", role: :primary },
      { name: "Biceps Brachii", role: :secondary }
    ]
  },
  {
    title: "Push-ups",
    muscle_group: :chest,
    muscles: [
      { name: "Pectoralis Major", role: :primary },
      { name: "Anterior Deltoid", role: :secondary },
      { name: "Triceps Brachii", role: :secondary },
      { name: "Rectus Abdominis", role: :secondary }
    ]
  },
  {
    title: "Plank",
    muscle_group: :abs,
    muscles: [
      { name: "Rectus Abdominis", role: :primary },
      { name: "Obliques", role: :primary },
      { name: "Transverse Abdominis", role: :primary },
      { name: "Anterior Deltoid", role: :secondary }
    ]
  },
  {
    title: "Lunges",
    muscle_group: :legs,
    muscles: [
      { name: "Quadriceps", role: :primary },
      { name: "Glutes", role: :primary },
      { name: "Hamstrings", role: :secondary }
    ]
  },
  {
    title: "Bicep Curls",
    muscle_group: :arm,
    muscles: [
      { name: "Biceps Brachii", role: :primary },
      { name: "Forearms", role: :secondary }
    ]
  },
  {
    title: "Tricep Extensions",
    muscle_group: :arm,
    muscles: [
      { name: "Triceps Brachii", role: :primary },
      { name: "Forearms", role: :secondary }
    ]
  },
  {
    title: "Leg Raises",
    muscle_group: :abs,
    muscles: [
      { name: "Rectus Abdominis", role: :primary },
      { name: "Obliques", role: :secondary }
    ]
  }
]

exercise_seeds.each do |attrs|
  exercise = Exercise.find_or_create_by!(title: attrs[:title]) do |ex|
    ex.muscle_group = attrs[:muscle_group]
  end

  # Clear existing muscle associations
  exercise.exercise_muscles.destroy_all

  # Add new muscle associations
  attrs[:muscles].each do |muscle_attr|
    muscle = Muscle.find_by!(name: muscle_attr[:name])
    ExerciseMuscle.create!(
      exercise: exercise,
      muscle: muscle,
      role: muscle_attr[:role]
    )
  end
end

# Assign permissions
perms = {
  "admin" => %w[destroy_user read_user read_dashboard update_any_user create_user read_role create_role update_role create_users_role destroy_users_role create_roles_permission destroy_roles_permission read_exercise create_exercise update_exercise destroy_exercise],
  "user"  => %w[read_dashboard update_own_user read_user]
}

perms.each do |role_name, keys|
  role = Role.find_by!(name: role_name)
  keys.each do |key|
    permission = Permission.find_or_create_by!(name: key)
    RolesPermission.find_or_create_by!(role: role, permission: permission)
  end
end
