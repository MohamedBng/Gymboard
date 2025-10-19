require 'rails_helper'

RSpec.describe Exercise, type: :model do
  subject { create(:exercise) }

  it 'has a valid factory' do
    exercise = build_stubbed(:exercise)
    expect(exercise).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
  end
end
