# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :create, User if user.has_permission?("create_user")
    can :read, User if user.has_permission?("read_user")
    can :read, :dashboard if user.has_permission?("read_dashboard")
    can :read, Role if user.has_permission?("read_role")
    can :create, Role if user.has_permission?("create_role")
    can :update, Role if user.has_permission?("update_role")
    can :destroy, UsersRole if user.has_permission?("destroy_users_role")
    can :create, UsersRole if user.has_permission?("create_users_role")
    can :create, RolesPermission if user.has_permission?("create_roles_permission")
    can :destroy, RolesPermission if user.has_permission?("destroy_roles_permission")

    can :read, Exercise if user.has_permission?("read_exercise")
    can :create, Exercise if user.has_permission?("create_exercise")
    can :update, Exercise if user.has_permission?("update_exercise")
    can :destroy, Exercise if user.has_permission?("destroy_exercise")

    can :read, TrainingSession if user.has_permission?("read_training_session")
    can :read, TrainingSession, user_id: user.id if user.has_permission?("read_own_training_session")

    can [ :update, :delete_profile_image ], User if user.has_permission?("update_any_user")
    can [ :update, :delete_profile_image ], User, id: user.id if user.has_permission?("update_own_user")


    can :destroy, User do |target_user|
      true if user.has_permission?("destroy_user") && user != target_user
    end
  end
end
