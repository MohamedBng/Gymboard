class Exercise < ApplicationRecord
  include Searchable

  validates :title, presence: true, uniqueness: { scope: :user_id }
  validates :muscle_group_id, :primary_muscle_id, presence: true, if: :public?

  belongs_to :muscle_group, optional: true
  belongs_to :user, optional: true
  belongs_to :primary_muscle, class_name: "Muscle", optional: true

  has_many :exercise_secondary_muscles, dependent: :destroy
  has_many :secondary_muscles, through: :exercise_secondary_muscles, source: :muscle
  has_many :training_session_exercises, dependent: :destroy
  has_many :training_sessions, through: :training_session_exercises

  def soft_delete!
    self.update!(delete_at: DateTime.now)
  end

  def restore_soft_delete!
    self.update!(delete_at: nil)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[primary_muscle muscle_group]
  end

  def complete?
    [ title, secondary_muscles, primary_muscle, muscle_group ].all?(&:present?)
  end

  def self.bulk_update_used_count(exercise_ids)
    return if exercise_ids.blank?

    body = exercise_ids.map do |id|
      {
        update: {
          _index: index_name,
          _id: id,
          data: {
            script: {
              source: "ctx._source.used_count += 1"
            }
          }
        }
      }
    end

    res = __elasticsearch__.client.bulk(body: body)

    Rails.logger.error("ES bulk errors: #{res}") if res["errors"]

    res
  end

  mappings do
    indexes :title, type: "text"
    indexes :user_id, type: "keyword"
    indexes :muscle_group_id, type: "keyword"
    indexes :public, type: "boolean"
    indexes :verified_at, type: "date"
  end

  def self.search(message: nil, muscle_group_id: nil, scope: nil, current_user_id: nil)
    at_least_one_exercise = [ message, muscle_group_id, scope ].count(&:present?) >= 1

    query = at_least_one_exercise ? ExerciseSearchQuery.call(message:, muscle_group_id:, scope:, current_user_id:) : { term: { public: true } }

    params = {
      query: query
    }

    self.__elasticsearch__.search(params).records
  end
end
