class RemoveNullConstraintsFromExerciseSets < ActiveRecord::Migration[8.0]
  def change
    change_column_null :exercise_sets, :reps, true
    change_column_null :exercise_sets, :weight, true
    change_column_null :exercise_sets, :rest, true
  end
end
