class Exercise < ApplicationRecord
  include Searchable

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

  mappings do
    indexes :title, type: "text"
    indexes :muscle_group_id, type: "keyword"
  end

  def self.search(message: nil, muscle_group_id: nil)
    query = {}

    if message.present? && muscle_group_id.present?
      query = bool_query(message: message, muscle_group_id:)
    elsif message.present?
      query = match_query(message: message)
    elsif muscle_group_id.present?
      query = term_query(muscle_group_id: muscle_group_id)
    end

    params = {
      query: query
    }

    self.__elasticsearch__.search(params).records
  end

  private

  def self.bool_query(message:, muscle_group_id:)
    {
      bool: {
        must: {
          match: {
            title: {
              query: message,
              fuzziness: "AUTO"
            }
          }
        },
        filter: {
          term: {
            muscle_group_id: {
              value: muscle_group_id,
              boost: 1.0
            }
          }
        }
      }
    }
  end

  def self.match_query(message:)
    {
      match: {
        title: {
          query: message,
          fuzziness: "AUTO"
        }
      }
    }
  end

  def self.term_query(muscle_group_id:)
    {
      term: {
        muscle_group_id: {
          value: muscle_group_id,
          boost: 1.0
        }
      }
    }
  end
end
