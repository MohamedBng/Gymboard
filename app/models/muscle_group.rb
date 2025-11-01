class MuscleGroup < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
