class DeleteRoleFromExerciseMuscles < ActiveRecord::Migration[8.0]
  def up
    remove_column :exercise_muscles, :role
  end

  def down
    add_column :exercise_muscles, :role, :integer
  end
end
