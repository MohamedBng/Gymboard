class TrainingSessions::TrainingSessionExercisesController < BaseController
  def create
    training_session = TrainingSession.find(params[:training_session_id])
    training_session_exercise = TrainingSessionExercise.create!(
      training_session_id: params[:training_session_id],
      exercise_id: params[:exercise_id]
    )

    training_session_exercise.exercise_sets.create

    redirect_to new_training_session_form_path(training_session)
  end


  def destroy
    training_session_exercise = TrainingSessionExercise.find(params[:id])
    training_session_exercise.destroy
    redirect_to new_training_session_form_path(training_session_exercise.training_session)
  end
end
