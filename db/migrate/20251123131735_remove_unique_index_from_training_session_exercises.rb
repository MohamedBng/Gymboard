class RemoveUniqueIndexFromTrainingSessionExercises < ActiveRecord::Migration[8.0]
  def change
    remove_index :training_session_exercises,
                 name: "index_training_session_exercises_unique"

    add_index :training_session_exercises,
              [:training_session_id, :exercise_id],
              name: "index_training_session_exercises_on_session_and_exercise"
  end
end
