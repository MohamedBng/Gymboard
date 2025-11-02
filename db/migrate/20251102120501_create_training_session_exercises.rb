class CreateTrainingSessionExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :training_session_exercises do |t|
      t.references :training_session, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true

      t.timestamps
    end

    add_index :training_session_exercises, [ :training_session_id, :exercise_id ],
              unique: true,
              name: 'index_training_session_exercises_unique'
  end
end
