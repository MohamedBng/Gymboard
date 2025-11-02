class ExerciseSet < ApplicationRecord
  belongs_to :training_session_exercise

  validates :reps, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :rest, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
