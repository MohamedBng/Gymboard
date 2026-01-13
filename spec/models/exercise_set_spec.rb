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

  describe 'before validation callbacks' do
    let(:exercise_set) { create(:exercise_set) }

    describe 'weight format' do
      it 'convert decimal weight (kg) in an integer (g)' do
        exercise_set.human_weight = 12.5
        exercise_set.save

        exercise_set.reload

        expect(exercise_set.weight).to eq(12500)
        expect(exercise_set.human_weight).to eq(12.5)
      end
    end

    describe '.set_position' do
      let(:second_exercise_set) { create(:exercise_set, training_session_exercise: exercise_set.training_session_exercise) }

      it "set a position by order of creation" do
        expect(exercise_set.position).to eq(1)
        expect(second_exercise_set.position).to eq(2)
      end
    end
  end
end
