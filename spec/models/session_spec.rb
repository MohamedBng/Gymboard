require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:title) }
  end

  describe 'custom validations' do
    describe '#start_time_before_end_time' do
      let(:session) { build(:session) }

      context 'when start_time is before end_time' do
        it 'is valid' do
          session.start_time = Time.current
          session.end_time = Time.current + 1.hour
          expect(session).to be_valid
        end
      end

      context 'when start_time equals end_time' do
        it 'is invalid' do
          session.start_time = Time.current
          session.end_time = session.start_time
          expect(session).not_to be_valid
          expect(session.errors[:end_time]).to include(I18n.t('activerecord.errors.models.session.attributes.end_time.must_be_after_start_time'))
        end
      end

      context 'when start_time is after end_time' do
        it 'is invalid' do
          session.start_time = Time.current + 1.hour
          session.end_time = Time.current
          expect(session).not_to be_valid
          expect(session.errors[:end_time]).to include(I18n.t('activerecord.errors.models.session.attributes.end_time.must_be_after_start_time'))
        end
      end

      context 'when start_time or end_time is nil' do
        it 'does not validate when start_time is nil' do
          session.start_time = nil
          session.end_time = Time.current
          expect(session).not_to be_valid
          expect(session.errors[:end_time]).not_to include(I18n.t('activerecord.errors.models.session.attributes.end_time.must_be_after_start_time'))
        end

        it 'does not validate when end_time is nil' do
          session.start_time = Time.current
          session.end_time = nil
          expect(session).not_to be_valid
          expect(session.errors[:end_time]).not_to include(I18n.t('activerecord.errors.models.session.attributes.end_time.must_be_after_start_time'))
        end
      end
    end
  end
end
