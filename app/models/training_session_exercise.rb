class TrainingSessionExercise < ApplicationRecord
  belongs_to :training_session
  belongs_to :exercise
  has_many :exercise_sets, dependent: :destroy

  accepts_nested_attributes_for :exercise_sets, allow_destroy: true
end
