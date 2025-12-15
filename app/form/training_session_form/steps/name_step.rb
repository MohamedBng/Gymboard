class TrainingSessionForm
  module Steps
    class NameStep < TrainingSessionForm::BaseStep
      attr_accessor :name

      PREVIOUS_STEP = "slot"
      STEP_NAME = "name"
      NEXT_STEP = nil

      NAME_MAX_LENGTH = 50

      validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }

      def step
        STEP_NAME
      end

      def next_step
        NEXT_STEP
      end

      def previous_step
        PREVIOUS_STEP
      end

      def self.permitted_params
        [ :name ]
      end

      def submit
        super(name:)
      end
    end
  end
end
