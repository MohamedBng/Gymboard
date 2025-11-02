class CreateExerciseSets < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_sets do |t|
      t.references :training_session_exercise, null: false, foreign_key: true
      t.integer :reps, null: false
      t.integer :weight, null: false
      t.integer :rest, null: false

      t.timestamps
    end
  end
end
