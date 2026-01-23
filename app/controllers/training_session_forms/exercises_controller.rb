class TrainingSessionForms::ExercisesController < Admin::BaseController
  def index
    @exercises = Exercise.search(
      message: params[:q],
      muscle_group_id: params[:muscle_group_id],
      scope: params[:scope],
      current_user_id: current_user.id
    ).includes(:muscle_group)

    render turbo_stream: turbo_stream.replace(
      "exercises_list",
      partial: "training_session_forms/training_session_exercises/exercises_list",
      locals: { exercises: @exercises, training_session_id: params[:training_session_id] }
    )
  end

  def new
    @exercise = Exercise.new

    render turbo_stream: turbo_stream.replace(
      "exercise-picker",
      partial: "training_session_forms/training_session_exercises/exercise_form",
      locals: {training_session_id: params[:training_session_id]}
    )
  end

  def create
    exercise = Exercise.new(user: current_user, **exercise_params)
    training_session = TrainingSession.find(params[:exercise][:training_session_id])

    @exercises = Exercise.search(
      message: params[:q],
      muscle_group_id: params[:muscle_group_id],
      scope: params[:scope],
      current_user_id: current_user.id
    ).includes(:muscle_group)

    if exercise.save
      render turbo_stream: turbo_stream.replace(
        'exercise-form',
        partial: 'training_session_forms/training_session_exercises/exercises_picker',
        locals: { exercises: @exercises, training_session_id: params[:training_session_id], training_session: training_session }
      )
    end
  end

  def exercise_params
    params.require(:exercise).permit(
      :title,
      :primary_muscle_id,
      :muscle_group_id,
      exercise_secondary_muscles_attributes: [
        :muscle_id
      ]
    )
  end
end
