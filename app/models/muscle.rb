class Muscle < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :muscle_group

  has_many :exercise_muscles, dependent: :destroy
  has_many :exercises, through: :exercise_muscles

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
