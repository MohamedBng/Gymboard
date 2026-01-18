class Exercise < ApplicationRecord
  include Searchable

  validates :title, presence: true, uniqueness: true

  belongs_to :muscle_group
  belongs_to :user, optional: true
  belongs_to :primary_muscle, class_name: "Muscle"

  has_many :exercise_secondary_muscles, dependent: :destroy
  has_many :secondary_muscles, through: :exercise_secondary_muscles, source: :muscle
  has_many :training_session_exercises, dependent: :destroy
  has_many :training_sessions, through: :training_session_exercises

  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[primary_muscle muscle_group]
  end

  mappings do
    indexes :title, type: "text"
    indexes :muscle_group_id, type: "keyword"
  end

  def self.search(message: nil, muscle_group_id: nil, scope: nil, current_user_id: nil)
    at_least_one_exercise = [ message, muscle_group_id, scope ].count(&:present?) >= 1

    query = at_least_one_exercise ? ExerciseSearchQuery.call(message:, muscle_group_id:, scope:, current_user_id:) : { match_all: {} }

    params = {
      query: query
    }

    self.__elasticsearch__.search(params).records
  end
end
