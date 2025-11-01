class MuscleGroup < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :muscles, dependent: :destroy
end
