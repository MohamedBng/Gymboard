class MuscleGroup < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :muscles, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :training_session_muscle_groups, dependent: :destroy
  has_many :training_sessions, through: :training_session_muscle_groups

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def name_capitalized
    name.capitalize
  end
end
