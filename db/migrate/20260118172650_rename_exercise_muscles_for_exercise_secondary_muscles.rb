class RenameExerciseMusclesForExerciseSecondaryMuscles < ActiveRecord::Migration[8.0]
  def up
    rename_table :exercise_muscles, :exercise_secondary_muscles
  end

  def down
    rename_table :exercise_secondary_muscles, :exercise_muscles
  end
end
