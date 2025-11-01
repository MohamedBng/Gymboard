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

# Seed muscle groups
load Rails.root.join('db', 'seeds', 'muscle_groups.rb')

# Seed muscles
load Rails.root.join('db', 'seeds', 'muscles.rb')

# Seed exercises
load Rails.root.join('db', 'seeds', 'exercises.rb')

# Seed training sessions
load Rails.root.join('db', 'seeds', 'training_sessions.rb')

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
