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

      training_session.status = :active if TrainingSessionForm::LAST_STEP == step

      if training_session.update!(attributes)
        session[:training_session_step] = next_step
        true
      else
        errors.add(:base, training_session.errors.full_messages)
        false
      end
    end
  end
end
