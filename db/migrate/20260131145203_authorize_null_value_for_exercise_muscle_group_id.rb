class AuthorizeNullValueForExerciseMuscleGroupId < ActiveRecord::Migration[8.0]
  def up
    change_column_null :exercises, :muscle_group_id, true
  end

  def down
    change_column_null :exercises, :muscle_group_id, false
  end
end
