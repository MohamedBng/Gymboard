class AddPrimaryMuscleIdOnExercise < ActiveRecord::Migration[8.0]
  def up
    add_reference :exercises, :primary_muscle, foreign_key: {to_table: :muscles}
  end

  def down
    remove_reference :exercises, :primary_muscle
  end
end
