class TrainingSessions::ExerciseSetsController < BaseController
  def create
    @training_session_exercise = TrainingSessionExercise.find(params[:training_session_exercise_id])
    @exercise_set = @training_session_exercise.exercise_sets.create

    redirect_to new_training_session_form_path(training_session_id: @training_session_exercise.training_session_id)
  end

  def destroy
    @exercise_set = ExerciseSet.find(params[:id])
    @exercise_set.destroy

    redirect_to new_training_session_form_path
  end
end
