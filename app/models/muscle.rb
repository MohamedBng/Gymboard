class Muscle < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :muscle_group, presence: true

  enum :muscle_group, [
    :chest,
    :back,
    :shoulders,
    :arm,
    :legs,
    :abs
  ]

  has_many :exercise_muscles, dependent: :destroy
  has_many :exercises, through: :exercise_muscles

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
