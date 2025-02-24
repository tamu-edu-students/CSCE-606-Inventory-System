require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:bin).optional }
    it { should belong_to(:item).optional }

    # Test Active Storage attachment if you're using shoulda-matchers >= 5.0
    # Otherwise, you can skip this or test it differently.
    it { should have_one_attached(:image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:image) }
  end
end
