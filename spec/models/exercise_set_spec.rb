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
end
