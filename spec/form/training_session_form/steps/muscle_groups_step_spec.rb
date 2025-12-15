require 'rails_helper'

RSpec.describe TrainingSessionForm::Steps::MuscleGroupsStep do
  let!(:training_session) { create(:training_session) }
  let!(:session_hash) { { training_session_step: TrainingSessionForm::Steps::MuscleGroupsStep::STEP_NAME } }
  let!(:training_session_params) { {} }
  let!(:step) { described_class.new(training_session:, session: session_hash, **training_session_params) }
  let!(:muscle_group) { create(:muscle_group) }

  describe '#step' do
    it "return current step" do
      expect(step.step).to eq(TrainingSessionForm::Steps::MuscleGroupsStep::STEP_NAME)
    end
  end

  describe '#next_step' do
    it "return current step" do
      expect(step.next_step).to eq(TrainingSessionForm::Steps::MuscleGroupsStep::NEXT_STEP)
    end
  end

  describe '#previous_step' do
    it "return previous step" do
      expect(step.previous_step).to eq(TrainingSessionForm::Steps::MuscleGroupsStep::PREVIOUS_STEP)
    end
  end

  describe '#submit' do
    context 'valid params' do
      let!(:training_session_params) {
        {
          "muscle_group_ids" => [ muscle_group.id ]
        }
      }

      it "return true" do
        expect(step.submit).to be_truthy
      end

      it "update the training_session_muscle_groups" do
        expect {
          step.submit
        }.to change { training_session.training_session_muscle_groups.count }.by(1)
      end
    end

    context 'invalid params' do
      let!(:training_session_params) {
        {
          "muscle_group_ids" => []
        }
      }

      it "return false" do
        expect(step.submit).to be_falsey
      end

      it "add a error" do
        step.submit

        expect(step.errors[:base]).to include(I18n.t("training_sessions.steps.muscle_groups.errors.no_muscle_groups"))
      end

      it "do not update the training_session_muscle_groups" do
        expect {
          step.submit
        }.not_to change { training_session.training_session_muscle_groups.count }
      end
    end
  end
end
