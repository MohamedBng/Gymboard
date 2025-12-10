require 'rails_helper'

RSpec.describe TrainingSessionForm::BaseStep do
  describe '#initialize' do
    let(:training_session) { create(:training_session) }
    let(:session_hash) { {} }

    it "sets training_session and session from params" do
      step = described_class.new(training_session: training_session, session: session_hash)

      expect(step.training_session).to eq(training_session)
      expect(step.session).to eq(session_hash)
    end
  end
end
