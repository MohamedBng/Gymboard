class TrainingSessionForm
  module Steps
    class MuscleGroupsStep < TrainingSessionForm::BaseStep
      validate :has_at_least_one_muscle_group

      PREVIOUS_STEP = "exercises"
      STEP_NAME = "muscle_groups"
      NEXT_STEP = "slot"

      attr_accessor :muscle_group_ids

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
        [ muscle_group_ids: [] ]
      end

      def submit
        super(muscle_group_ids: muscle_group_ids)
      end

      private

      def has_at_least_one_muscle_group
        if muscle_group_ids.compact_blank.empty?
          errors.add(:base, I18n.t("training_sessions.steps.muscle_groups.errors.no_muscle_groups"))
        end
      end
    end
  end
end
