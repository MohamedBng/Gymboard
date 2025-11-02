require 'rails_helper'

RSpec.describe TrainingSessionExercise, type: :model do
  subject { create(:training_session_exercise) }

  it 'has a valid factory' do
    training_session_exercise = build_stubbed(:training_session_exercise)
    expect(training_session_exercise).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:training_session) }
    it { should belong_to(:exercise) }
  end
end
