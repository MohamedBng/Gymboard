require 'rails_helper'

RSpec.describe ExerciseMuscle, type: :model do
  subject { create(:exercise_muscle) }

  it 'has a valid factory' do
    exercise_muscle = build_stubbed(:exercise_muscle)
    expect(exercise_muscle).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:exercise) }
    it { should belong_to(:muscle) }
  end
end
