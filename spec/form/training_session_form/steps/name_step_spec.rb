require 'rails_helper'

RSpec.describe TrainingSessionForm::Steps::NameStep do
  let!(:user) { create(:user) }
  let!(:training_session) { create(:training_session, user: user) }
  let!(:session_hash) { { training_session_step: TrainingSessionForm::Steps::NameStep::STEP_NAME } }
  let(:training_session_params) { {} }
  let!(:name_step) { described_class.new(training_session:, session: session_hash, **training_session_params) }

  describe '#step' do
    it 'returns "name"' do
      expect(name_step.step).to eq(TrainingSessionForm::Steps::NameStep::STEP_NAME)
    end
  end

  describe '#next_step' do
    it 'returns nil' do
      expect(name_step.next_step).to eq(TrainingSessionForm::Steps::NameStep::NEXT_STEP)
    end
  end

  describe '#previous_step' do
    it 'returns "exercises"' do
      expect(name_step.previous_step).to eq(TrainingSessionForm::Steps::NameStep::PREVIOUS_STEP)
    end
  end

  describe '#submit' do
    context "when params are valid" do
      let!(:training_session_params) {
        {
          name: "My Training Session"
        }
      }

      it 'returns true' do
        expect(name_step.submit).to be true
      end

      it 'has no errors' do
        name_step.submit
        expect(name_step.errors).to be_empty
      end
    end

    context "when params are invalid" do
      context 'when training_session has no name' do
        let!(:training_session_params) { {} }

        it 'returns false' do
          expect(name_step.submit).to be false
        end

        it 'adds an error' do
          name_step.submit
          expect(name_step.errors[:name]).to include(I18n.t('errors.messages.blank'))
        end
      end

      context 'when training_session has a blank name' do
        let!(:training_session_params) {
          {
            name: ""
          }
        }

        it 'returns false' do
          expect(name_step.submit).to be false
        end

        it 'adds an error' do
          name_step.submit
          expect(name_step.errors[:name]).to include(I18n.t('errors.messages.blank'))
        end
      end

      context 'when training_session has a name with only whitespaces' do
        let!(:training_session_params) {
          {
            name: "  "
          }
        }

        it 'returns false' do
          expect(name_step.submit).to be false
        end

        it 'adds an error' do
          name_step.submit
          expect(name_step.errors[:name]).to include(I18n.t("errors.messages.blank"))
        end
      end
    end
  end
end
