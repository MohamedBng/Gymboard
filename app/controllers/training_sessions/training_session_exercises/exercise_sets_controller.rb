class TrainingSessions::TrainingSessionExercises::ExerciseSetsController < BaseController
  def create
    training_session_exercise = TrainingSessionExercise.find(params[:training_session_exercise_id])
    exercise_set = training_session_exercise.exercise_sets.create

    redirect_to new_training_session_form_path(params[:training_session_id])
  end

  def destroy
    exercise_set = ExerciseSet.find_by(id: params[:id])
    exercise_set.destroy if exercise_set

    redirect_to new_training_session_form_path(params[:training_session_id])
  end
end
