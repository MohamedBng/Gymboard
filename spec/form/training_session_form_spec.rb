require 'rails_helper'

RSpec.describe TrainingSessionForm do
  let(:user) { create(:user) }
  let(:session_hash) { {} }

  describe '#initialize' do
    context 'when current user do not have a draft training_session' do
      it 'creates a training session' do
        expect {
          described_class.new(user:, session: session_hash)
        }.to change { TrainingSession.count }.by(1)
      end

      it 'creates a training session with draft status' do
        form = described_class.new(user:, session: session_hash)

        expect(form.training_session.status).to eq('draft')
      end

      it 'creates a training session associated with the user' do
        form = described_class.new(user:, session: session_hash)

        expect(form.training_session.user).to eq(user)
      end

      it 'assigns the training session to the form' do
        form = described_class.new(user:, session: session_hash)

        expect(form.training_session).to be_a(TrainingSession)
        expect(form.training_session).to be_persisted
      end
    end

    context 'when session has no training_session_step defined' do
      it 'sets the step to "exercises" by default' do
        described_class.new(user:, session: session_hash)

        expect(session_hash[:training_session_step]).to eq("exercises")
      end
    end

    context 'when user already has a draft training session' do
      let!(:existing_training_session) { create(:training_session, user: user, status: :draft) }

      it 'reuses the existing training session' do
        expect {
          described_class.new(user:, session: session_hash)
        }.not_to change { TrainingSession.count }
      end

      it 'returns the existing training session' do
        form = described_class.new(user:, session: session_hash)

        expect(form.training_session).to eq(existing_training_session)
      end
    end
  end

  describe '#current_step_instance' do
    let(:form) { described_class.new(user:, session: session_hash) }

    context 'when step is "exercises"' do
      let(:session_hash) { { training_session_step: "exercises" } }

      it 'returns an ExercisesStep instance' do
        expect(form.current_step_instance).to be_a(TrainingSessionForm::Steps::ExercisesStep)
      end
    end

    context 'when step is "name"' do
      let(:session_hash) { { training_session_step: "name" } }

      it 'returns a NameStep instance' do
        expect(form.current_step_instance).to be_a(TrainingSessionForm::Steps::NameStep)
      end
    end
  end

  describe '#current_step' do
    let(:form) { described_class.new(user:, session: session_hash) }

    context 'when session step is "exercises"' do
      let(:session_hash) { { training_session_step: "exercises" } }

      it 'returns "exercises"' do
        expect(form.current_step).to eq("exercises")
      end
    end

    context 'when session step is "name"' do
      let(:session_hash) { { training_session_step: "name" } }

      it 'returns "name"' do
        expect(form.current_step).to eq("name")
      end
    end
  end

  describe '#next_step' do
    let(:form) { described_class.new(user:, session: session_hash) }

    context 'when current step is "exercises"' do
      let(:session_hash) { { training_session_step: "exercises" } }

      it 'returns "name"' do
        expect(form.next_step).to eq("name")
      end
    end

    context 'when current step is "name"' do
      let(:session_hash) { { training_session_step: "name" } }

      it 'returns nil (last step)' do
        expect(form.next_step).to eq('slot')
      end
    end

    context 'when current step is "slot"' do
      let(:session_hash) { { training_session_step: "slot" } }

      it 'returns nil (last step)' do
        expect(form.next_step).to be_nil
      end
    end
  end

  describe '#go_back!' do
    let(:form) { described_class.new(user:, session: session_hash) }

    context 'when current step is "slot"' do
      let(:session_hash) { { training_session_step: "slot" } }

      it 'changes the session step to "exercises"' do
        form.go_back!

        expect(session_hash[:training_session_step]).to eq("name")
      end
    end

    context 'when current step is "name"' do
      let(:session_hash) { { training_session_step: "name" } }

      it 'changes the session step to "exercises"' do
        form.go_back!

        expect(session_hash[:training_session_step]).to eq("exercises")
      end
    end

    context 'when current step is "exercises"' do
      let(:session_hash) { { training_session_step: "exercises" } }

      it 'does not change the session step (first step)' do
        form.go_back!

        expect(session_hash[:training_session_step]).to eq("exercises")
      end
    end
  end
end

