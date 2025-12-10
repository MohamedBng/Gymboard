class TrainingSessionForm
  module Steps
    class ExercisesStep < TrainingSessionForm::BaseStep
      validate :at_least_one_exercise
      validate :training_session_exercises_validity

      attr_accessor :training_session_exercises_attributes

      NEXT_STEP = 'name'
      STEP_NAME = "exercises"

      def step
        STEP_NAME
      end

      def next_step
        NEXT_STEP
      end

      def previous_step
        nil
      end

      def self.permitted_params
        [
          training_session_exercises_attributes: [
            :id,
            :exercise_id,
            exercise_sets_attributes: [
              :id,
              :weight,
              :rest,
              :reps
            ]
          ]
        ]
      end

      def submit
        super(training_session_exercises_attributes: training_session_exercises_attributes)
      end

      private

      def at_least_one_exercise
        unless training_session_exercises_attributes.any?
          errors.add(:base, I18n.t("training_sessions.steps.exercises.errors.no_exercises"))
        end
      end

      def training_session_exercises_validity
        training_session_exercises_attributes.each do |k, training_session_exercise|
          unless training_session_exercise["exercise_sets_attributes"].any?
            errors.add(:base, I18n.t("training_sessions.steps.exercises.errors.no_sets"))
          end

          training_session_exercise["exercise_sets_attributes"].each do |k, exercise_set|
            if exercise_set["reps"].blank? || exercise_set["weight"].blank? || exercise_set["rest"].blank?
              errors.add(:base, I18n.t("training_sessions.steps.exercises.errors.incomplete_sets"))
            elsif exercise_set["reps"].to_i <= 0 || exercise_set["weight"].to_i < 0 || exercise_set["rest"].to_i < 0
              errors.add(:base, I18n.t("training_sessions.steps.exercises.errors.invalid_values"))
            end
          end
        end
      end
    end
  end
end
