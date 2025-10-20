class Admin::ExercisesController < Admin::BaseController
  load_and_authorize_resource class: "Exercise"

  def index
    @q = Exercise.ransack(params[:q])
    @exercises = @q.result(distinct: true)
                  .includes(exercise_muscles: :muscle)
                  .page(params[:page])
                  .per(10)
  end
end
