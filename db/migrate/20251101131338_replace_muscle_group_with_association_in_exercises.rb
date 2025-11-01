class ReplaceMuscleGroupWithAssociationInExercises < ActiveRecord::Migration[8.0]
  def change
    remove_column :exercises, :muscle_group, :integer
    add_reference :exercises, :muscle_group, null: false, foreign_key: true
  end
end
