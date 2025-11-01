class TrainingSessionMuscleGroup < ApplicationRecord
  belongs_to :training_session
  belongs_to :muscle_group
end
