class Elasticsearch::Exercise::BulkUpdateUsedCountJob < ApplicationJob
  queue_as :elasticsearch
  self.enqueue_after_transaction_commit = true

  def perform(exercise_ids)
    ::Exercise.bulk_update_used_count(exercise_ids)
  end
end
