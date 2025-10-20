class Exercise < ApplicationRecord
  validates :title, presence: true, uniqueness: true
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
  has_many :muscles, through: :exercise_muscles

  def self.ransackable_attributes(auth_object = nil)
    %w[title muscle_group]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[muscles]
  end
end
