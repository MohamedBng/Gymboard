require 'rails_helper'

RSpec.describe TrainingSession, type: :model do
  let(:user) { create(:user) }

  it 'has a valid factory' do
    training_session = build_stubbed(:training_session)
    expect(training_session).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:training_session_exercises).dependent(:destroy) }
    it { should have_many(:exercises).through(:training_session_exercises) }
    it { should have_many(:training_session_muscle_groups).dependent(:destroy) }
    it { should have_many(:muscle_groups).through(:training_session_muscle_groups) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:training_session_exercises).allow_destroy(true) }
  end

  describe 'status enum' do
    it 'has draft status by default' do
      training_session = TrainingSession.create(user: user)
      expect(training_session.status).to eq('draft')
    end

    it 'can be set to active' do
      training_session = create(:training_session, status: :active)
      expect(training_session.status).to eq('active')
    end
  end

  context 'when training_session is in draft status' do
    let(:training_session) { build(:training_session, status: :draft) }

    describe 'validations' do
      it 'does not require start_time' do
        training_session.start_time = nil
        expect(training_session).to be_valid
      end

      it 'does not require end_time' do
        training_session.end_time = nil
        expect(training_session).to be_valid
      end

      it 'does not validate end_time_after_start_time' do
        training_session.start_time = Time.current
        training_session.end_time = Time.current - 1.hour
        expect(training_session).to be_valid
      end

      it 'allows both start_time and end_time to be nil' do
        training_session.start_time = nil
        training_session.end_time = nil
        expect(training_session).to be_valid
      end
    end

    describe 'default name generation' do
      context 'when name is blank and start_time is nil' do
        it 'does not set default name' do
          training_session.name = nil
          training_session.start_time = nil
          training_session.valid?
          expect(training_session.name).to be_nil
        end
      end

      context 'when name is blank and start_time is present' do
        it 'sets default name from start_time' do
          start_time = Time.zone.local(2025, 10, 30, 10, 0, 0)
          training_session.name = nil
          training_session.start_time = start_time
          training_session.valid?
          expect(training_session.name).to eq("Session — #{start_time.strftime('%B %d')}")
        end
      end

      context 'when name is provided' do
        it 'does not override the name' do
          training_session.name = "Custom Session"
          training_session.valid?
          expect(training_session.name).to eq("Custom Session")
        end
      end
    end
  end

  context 'when training_session is in active status' do
    let(:training_session) { build(:training_session, status: :active) }

    describe 'validations' do
      it 'requires start_time' do
        training_session.start_time = nil
        expect(training_session).not_to be_valid
        expect(training_session.errors[:start_time]).to include("can't be blank")
      end

      it 'requires end_time' do
        training_session.end_time = nil
        expect(training_session).not_to be_valid
        expect(training_session.errors[:end_time]).to include("can't be blank")
      end

      context 'when end_time is after start_time' do
        it 'is valid' do
          training_session.start_time = Time.current
          training_session.end_time = Time.current + 1.hour
          expect(training_session).to be_valid
        end
      end

      context 'when end_time equals start_time' do
        it 'is invalid' do
          time = Time.current
          training_session.start_time = time
          training_session.end_time = time
          expect(training_session).not_to be_valid
          expect(training_session.errors[:end_time]).to include(
            I18n.t('activerecord.errors.models.training_session.attributes.end_time.must_be_after_start_time')
          )
        end
      end

      context 'when end_time is before start_time' do
        it 'is invalid' do
          training_session.start_time = Time.current + 1.hour
          training_session.end_time = Time.current
          expect(training_session).not_to be_valid
          expect(training_session.errors[:end_time]).to include(
            I18n.t('activerecord.errors.models.training_session.attributes.end_time.must_be_after_start_time')
          )
        end
      end
    end

    describe 'default name generation' do
      context 'when name is blank and start_time is present' do
        it 'sets default name from start_time' do
          start_time = Time.zone.local(2025, 10, 30, 10, 0, 0)
          training_session.name = nil
          training_session.start_time = start_time
          training_session.end_time = start_time + 1.hour
          training_session.valid?
          expect(training_session.name).to eq("Session — #{start_time.strftime('%B %d')}")
        end
      end

      context 'when name is provided' do
        it 'does not override the name' do
          training_session.name = "Custom Session"
          training_session.valid?
          expect(training_session.name).to eq("Custom Session")
        end
      end
    end
  end
end
