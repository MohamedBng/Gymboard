require 'rails_helper'

RSpec.describe ExerciseSecondaryMuscle, type: :model do
  subject { create(:exercise_secondary_muscle) }

  it 'has a valid factory' do
    exercise_secondary_muscle = build_stubbed(:exercise_secondary_muscle)
    expect(exercise_secondary_muscle).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:exercise) }
    it { should belong_to(:muscle) }
  end
end
