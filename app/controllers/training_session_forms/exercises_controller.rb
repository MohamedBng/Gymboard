class TrainingSessionForms::ExercisesController < Admin::BaseController
  def index
    @exercises = Exercise.search(
      message: params[:q],
      muscle_group_id: params[:muscle_group_id],
      scope: params[:scope],
    ).includes(:muscle_group)

    render turbo_stream: turbo_stream.replace(
      "exercises_list",
      partial: "training_session_forms/training_session_exercises/exercises_list",
      locals: { exercises: @exercises, training_session_id: params[:training_session_id] }
    )
  end
end
