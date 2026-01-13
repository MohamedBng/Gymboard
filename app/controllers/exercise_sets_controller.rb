class ExerciseSetsController < BaseController
  def update
    exercise_set = ExerciseSet.find_by(id: params[:id])
    exercise_set.update(exercise_set_params)
    head :ok
  end

  private

  def exercise_set_params
    params.require(:exercise_set).permit(:human_weight, :rest, :reps)
  end
end
