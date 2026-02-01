class TrainingSessionForm
  class BaseStep
    include ActiveModel::Model
    include ActiveModel::Attributes

    attr_accessor :training_session_params, :training_session, :session

    def step
      raise NotImplementedError
    end

    def next_step
      raise NotImplementedError
    end

    def previous_step
      raise NotImplementedError
    end

    def submit(attributes = {})
      return false unless valid?

      ActiveRecord::Base.transaction do
        training_session.update!(attributes)

        TrainingSessionFinalizerService.call(training_session) if TrainingSessionForm::LAST_STEP == step

        session[:training_session_step] = next_step

        true
      end

    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.record.errors.full_messages)
      false
    end
  end
end
