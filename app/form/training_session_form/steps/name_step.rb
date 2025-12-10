class TrainingSessionForm
  module Steps
    class NameStep < TrainingSessionForm::BaseStep
      attr_accessor :name

      NAME_MAX_LENGTH = 50

      validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }

      def step
        "name"
      end

      def next_step
        "slot"
      end

      def previous_step
        "exercises"
      end

      def self.permitted_params
        [:name]
      end

      def submit
        super(name:)
      end
    end
  end
end

