class ExerciseSet < ApplicationRecord
  belongs_to :training_session_exercise

  before_validation :set_position, on: :create

  def human_weight
    weight && weight / 1000.00
  end

  def human_weight=(human_value)
    self.weight = human_value.present? ? (BigDecimal(human_value.to_s) * 1000).to_i : nil
  end

  private

  def set_position
    self.position = (training_session_exercise&.exercise_sets&.maximum(:position) || 0) + 1
  end
end
