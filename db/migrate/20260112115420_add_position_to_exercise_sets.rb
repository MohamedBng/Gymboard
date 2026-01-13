class AddPositionToExerciseSets < ActiveRecord::Migration[8.0]
  def change
    add_column :exercise_sets, :position, :integer
  end
end
