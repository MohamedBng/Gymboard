class TrainingSessionForms::ExercisesController < Admin::BaseController
  def index
    if params[:q].present? || params[:muscle_group_id].present?
      @exercises = Exercise.search(message: params[:q], muscle_group_id: params[:muscle_group_id]).includes(:muscle_group)
    else
      @exercises = Exercise.all.includes(:muscle_group)
    end

    render turbo_stream: turbo_stream.replace(
      "exercises_list",
      partial: "training_session_forms/training_session_exercises/exercises_list",
      locals: { exercises: @exercises, training_session_id: params[:training_session_id] }
    )
  end
end
