require 'rails_helper'

RSpec.describe TrainingSessionFinalizerService, type: :service do
  let(:active_training_session) { create(:training_session, status: :active) }
  let(:draft_training_session) { create(:training_session, status: :draft) }

  context "when training session status is active" do
    it "do not enqueue IncrementExerciseUsedCountJob" do
      expect {
        described_class.call(active_training_session)
      }.to_not have_enqueued_job(IncrementExerciseUsedCountJob)
    end
  end

  context "when training session status is draft" do
    it "set training session status to active" do
      described_class.call(draft_training_session)

      draft_training_session.reload

      expect(draft_training_session.status).to eq('active')
    end

    it "Enqueue IncrementExerciseUsedCountJob" do
      expect {
        described_class.call(draft_training_session)
      }.to have_enqueued_job(IncrementExerciseUsedCountJob)
    end
  end
end
