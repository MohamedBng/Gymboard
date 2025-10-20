class ExerciseMuscle < ApplicationRecord
  belongs_to :exercise
  belongs_to :muscle

  enum :role, [
    :primary,
    :secondary
  ]

  validates :role, presence: true
end
