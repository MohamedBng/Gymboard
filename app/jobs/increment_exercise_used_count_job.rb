class IncrementExerciseUsedCountJob < ApplicationJob
  queue_as :default
  self.enqueue_after_transaction_commit = true

  def perform(training_session_id)
    training_session = TrainingSession.find_by(id: training_session_id)
    return unless training_session

    ActiveRecord::Base.transaction do
      ids = training_session.exercise_ids.uniq

      updated_rows = Exercise.where(id: ids).update_all("used_count = used_count + 1")

      if updated_rows != ids.size
        Rails.logger.error(
          "Mismatch update_all: expected #{ids.size}, got #{updated_rows} " \
          "for training_session=#{training_session.id}"
        )
        raise ActiveRecord::Rollback
      end

      Elasticsearch::Exercise::BulkUpdateUsedCountJob.perform_later(ids)
    end
  end
end
