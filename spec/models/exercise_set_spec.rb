require 'rails_helper'

RSpec.describe ExerciseSet, type: :model do
  subject { build(:exercise_set) }

  it 'has a valid factory' do
    exercise_set = build_stubbed(:exercise_set)
    expect(exercise_set).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:training_session_exercise) }
  end

  describe 'validations' do
    describe 'presence' do
      it { should validate_presence_of(:reps) }
      it { should validate_presence_of(:weight) }
      it { should validate_presence_of(:rest) }
    end

    describe 'numericality' do
      it { should validate_numericality_of(:reps).only_integer.is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:weight).only_integer.is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:rest).only_integer.is_greater_than_or_equal_to(0) }
    end

    describe 'rejecting negative values' do
      it 'rejects negative reps' do
        exercise_set = build(:exercise_set, reps: -1)
        expect(exercise_set).not_to be_valid
        expect(exercise_set.errors[:reps]).to include(I18n.t('activerecord.errors.models.exercise_set.attributes.reps.greater_than_or_equal_to', count: 0))
      end

      it 'rejects negative weight' do
        exercise_set = build(:exercise_set, weight: -1)
        expect(exercise_set).not_to be_valid
        expect(exercise_set.errors[:weight]).to include(I18n.t('activerecord.errors.models.exercise_set.attributes.weight.greater_than_or_equal_to', count: 0))
      end

      it 'rejects negative rest' do
        exercise_set = build(:exercise_set, rest: -1)
        expect(exercise_set).not_to be_valid
        expect(exercise_set.errors[:rest]).to include(I18n.t('activerecord.errors.models.exercise_set.attributes.rest.greater_than_or_equal_to', count: 0))
      end
    end

    describe 'accepting zero' do
      it 'accepts zero for reps' do
        exercise_set = build(:exercise_set, reps: 0)
        expect(exercise_set).to be_valid
      end

      it 'accepts zero for weight' do
        exercise_set = build(:exercise_set, weight: 0)
        expect(exercise_set).to be_valid
      end

      it 'accepts zero for rest' do
        exercise_set = build(:exercise_set, rest: 0)
        expect(exercise_set).to be_valid
      end
    end
  end
end
