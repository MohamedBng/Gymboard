require 'rails_helper'

RSpec.describe MuscleGroup, type: :model do
  subject { create(:muscle_group) }

  it 'has a valid factory' do
    muscle_group = build_stubbed(:muscle_group)
    expect(muscle_group).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
