require 'rails_helper'

RSpec.describe TrainingSession, type: :model do
  subject { create(:training_session) }

  it 'has a valid factory' do
    training_session = build_stubbed(:training_session)
    expect(training_session).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
  end

  describe 'custom validation' do
    context 'when end_time is after start_time' do
      it 'is valid' do
        training_session = build(:training_session,
          start_time: Time.current,
          end_time: Time.current + 1.hour
        )
        expect(training_session).to be_valid
      end
    end

    context 'when end_time equals start_time' do
      it 'is invalid' do
        time = Time.current
        training_session = build(:training_session,
          start_time: time,
          end_time: time
        )
        expect(training_session).not_to be_valid
        expect(training_session.errors[:end_time]).to include(
          I18n.t('activerecord.errors.models.training_session.attributes.end_time.must_be_after_start_time')
        )
      end
    end

    context 'when end_time is before start_time' do
      it 'is invalid' do
        training_session = build(:training_session,
          start_time: Time.current + 1.hour,
          end_time: Time.current
        )
        expect(training_session).not_to be_valid
        expect(training_session.errors[:end_time]).to include(
          I18n.t('activerecord.errors.models.training_session.attributes.end_time.must_be_after_start_time')
        )
      end
    end
  end

  describe 'default name generation' do
    context 'when name is blank' do
      it 'sets default name from start_time' do
        start_time = Time.zone.local(2025, 10, 30, 10, 0, 0)
        training_session = build(:training_session,
          name: nil,
          start_time: start_time,
          end_time: start_time + 1.hour
        )
        training_session.valid?
        expect(training_session.name).to eq("Session — #{start_time.strftime('%B %d')}")
      end
    end

    context 'when name is provided' do
      it 'does not override the name' do
        training_session = build(:training_session, name: "Custom Session")
        training_session.valid?
        expect(training_session.name).to eq("Custom Session")
      end
    end

    context 'when name is blank but start_time is nil' do
      it 'does not set default name' do
        training_session = build(:training_session, name: nil, start_time: nil)
        training_session.valid?
        expect(training_session.name).to be_nil
      end
    end
  end

  describe 'localized error messages' do
    context 'in English' do
      around do |example|
        I18n.with_locale(:en) do
          example.run
        end
      end

      it 'has correct blank message for start_time' do
        training_session = build(:training_session, start_time: nil)
        training_session.valid?
        expect(training_session.errors[:start_time]).to include("can't be blank")
      end

      it 'has correct blank message for end_time' do
        training_session = build(:training_session, end_time: nil)
        training_session.valid?
        expect(training_session.errors[:end_time]).to include("can't be blank")
      end
    end

    context 'in French' do
      around do |example|
        I18n.with_locale(:fr) do
          example.run
        end
      end

      it 'has correct blank message for start_time' do
        training_session = build(:training_session, start_time: nil)
        training_session.valid?
        expect(training_session.errors[:start_time]).to include("ne peut pas être vide")
      end

      it 'has correct blank message for end_time' do
        training_session = build(:training_session, end_time: nil)
        training_session.valid?
        expect(training_session.errors[:end_time]).to include("ne peut pas être vide")
      end
    end
  end
end
