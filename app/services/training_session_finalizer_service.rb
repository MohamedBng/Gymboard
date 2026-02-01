class TrainingSessionFinalizerService
  attr_accessor :training_session

  def self.call(training_session)
    new(training_session).call
  end

  def initialize(training_session)
    @training_session = training_session
  end

  def call
    updated = TrainingSession.where(id: training_session.id, status: :draft).update_all(status: :active)

    return unless updated == 1

    increment_exercise_used_count!
  end

  def increment_exercise_used_count!
    IncrementExerciseUsedCountJob.perform_later(training_session.id)
  end
end
