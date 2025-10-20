class CreateExerciseMuscles < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_muscles do |t|
      t.references :exercise, null: false, foreign_key: true
      t.references :muscle, null: false, foreign_key: true
      t.integer :role, null: false

      t.timestamps
    end
  end
end
