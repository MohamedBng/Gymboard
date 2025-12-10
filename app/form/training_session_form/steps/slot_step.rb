class TrainingSessionForm
  module Steps
    class SlotStep < TrainingSessionForm::BaseStep
      attr_accessor :start_time, :end_time

      validates :start_time, :end_time, presence: true

      validate :validate_start_time_before_end_time

      def step
        "slot"
      end

      def next_step
        nil
      end

      def previous_step
        "name"
      end

      def self.permitted_params
        [ :start_time, :end_time ]
      end

      def submit
        super(start_time:, end_time:)
      end

      private

      def validate_start_time_before_end_time
        return false unless start_time && end_time

        unless start_time < end_time
          errors.add(:start_time, I18n.t("training_sessions.steps.slot.errors.must_be_before_end_time"))
        end
      end
    end
  end
end
