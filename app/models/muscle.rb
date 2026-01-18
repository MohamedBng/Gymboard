class Muscle < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :muscle_group

  has_many :exercise_secondary_muscles, dependent: :destroy
  has_many :secondary_exercises, through: :exercise_secondary_muscles
  has_many :primary_exercises, class_name: "Exercise", foreign_key: :primary_muscle_id, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
