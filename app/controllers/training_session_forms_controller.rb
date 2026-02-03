class TrainingSessionFormsController < BaseController
  load_and_authorize_resource class: "TrainingSession", except: :go_back_to_previous_step

  def new
    @form = TrainingSessionForm.new(user: current_user, session: session)
    @step = @form.current_step_instance
  end

  def update
    @form = TrainingSessionForm.new(user: current_user, session: session)
    step_params = training_session_form_params(@form.current_step_class)

    @step = @form.current_step_instance(step_params)

    if @step.submit
      if @step.next_step.nil?
        redirect_to training_sessions_path, notice: t("training_sessions.create.success")
      else
        redirect_to new_training_session_form_path, data: { turbo_frame: "main", turbo_action: "advance" }
      end
    else
      flash.now[:error] = @step.errors.full_messages.join(", ")
      @exercises = Exercise.all.includes(:muscle_group)
      render :new, status: :unprocessable_content
    end
  end

  def go_back_to_previous_step
    @form = TrainingSessionForm.new(user: current_user, session: session)
    @form.go_back!
    redirect_to new_training_session_form_path
  end

  private

  def training_session_form_params(step)
    params.require(:training_session).permit(step.permitted_params)
  end
end
