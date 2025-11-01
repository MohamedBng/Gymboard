class ReplaceMuscleGroupWithAssociationInMuscles < ActiveRecord::Migration[8.0]
  def change
    remove_column :muscles, :muscle_group, :integer
    add_reference :muscles, :muscle_group, null: false, foreign_key: true
  end
end
