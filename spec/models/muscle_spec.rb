require 'rails_helper'

RSpec.describe Muscle, type: :model do
  subject { create(:muscle) }

  it 'has a valid factory' do
    muscle = build_stubbed(:muscle)
    expect(muscle).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:muscle_group) }
  end
end
