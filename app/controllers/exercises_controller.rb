class ExercisesController < BaseController
  def new
    session[:redirect_to] = request.referrer
    @exercise = Exercise.new
  end

  def create
    @exercise = Exercise.new(user: current_user, **exercise_params)

    if @exercise.save
      flash[:success] = "Exercise successfully created"
      if session[:redirect_to]
        redirect_to session.delete(:redirect_to)
      else
        redirect_to training_sessions_path
      end
    else
      flash.now[:error] = @exercise.errors.full_messages.join(",")

      render :new
    end
  end

  def back_to_picker
    render turbo_stream: turbo_stream.replace(
      "exercise-form",
      partial: "training_session_forms/training_session_exercises/exercises_picker",
      locals: { training_session_id: params[:training_session_id] }
    )
  end

  def exercise_params
    params.require(:exercise).permit(
      :title,
      :primary_muscle_id,
      :muscle_group_id,
      :public,
      secondary_muscle_ids: []
    )
  end
end
