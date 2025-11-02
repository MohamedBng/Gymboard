class Exercise < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  belongs_to :muscle_group

  has_many :exercise_muscles, dependent: :destroy
  has_many :muscles, through: :exercise_muscles
  has_many :training_session_exercises, dependent: :destroy
  has_many :training_sessions, through: :training_session_exercises

  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[muscles muscle_group]
  end
end
