class TrainingSessions::TrainingSessionExercisesController < BaseController
  def new
    @exercises = Exercise.search(
      message: params[:q],
      muscle_group_id: params[:muscle_group_id],
      scope: params[:scope],
      current_user_id: current_user.id
    ).includes(:muscle_group)

    @training_session_id = params[:training_session_id]
  end

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
    training_session_exercise = TrainingSessionExercise.find_by(id: params[:id])
    training_session_exercise.destroy if training_session_exercise
    redirect_to new_training_session_form_path(params[:training_session_id])
  end
end
