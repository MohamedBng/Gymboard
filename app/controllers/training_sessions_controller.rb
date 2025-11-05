class TrainingSessionsController < BaseController
  load_and_authorize_resource class: "TrainingSession"

  def index
    @q = @training_sessions.ransack(params[:q])
    @training_sessions = @q.result(distinct: true)
                           .includes(:exercises, :muscle_groups)
                           .order(start_time: :desc)
                           .page(params[:page])
                           .per(6)
  end
end
