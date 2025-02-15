require 'rails_helper'

RSpec.describe Bin, type: :model do
  # Setup test data
  let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!') }
  let(:valid_attributes) do
    {
      name: 'Storage Box',
      user: user
    }
  end

  # Validations
  describe 'validations' do
    it 'is valid with valid attributes' do
      bin = Bin.new(valid_attributes)
      expect(bin).to be_valid
    end

    it 'requires a name' do
      bin = Bin.new(valid_attributes.merge(name: nil))
      expect(bin).not_to be_valid
      expect(bin.errors[:name]).to include("can't be blank")
    end

    it 'belongs to a user' do
      bin = Bin.new(valid_attributes.merge(user: nil))
      expect(bin).not_to be_valid
    end
  end

  # Associations
  describe 'associations' do
    let(:bin) { Bin.create(valid_attributes) }

    it 'belongs to a user with counter cache' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:counter_cache]).to be true
    end

    it 'has many items' do
      association = described_class.reflect_on_association(:items)
      expect(association.macro).to eq :has_many
    end

    it 'has many attached bin pictures' do
      expect(bin).to respond_to(:bin_pictures)
      expect(bin.bin_pictures).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  # Instance Methods
  describe '#items_in_bin' do
    let(:bin) { Bin.create!(valid_attributes) }
    
    it 'returns items belonging to the bin' do
      item1 = Item.create!(name: 'Item 1', bin: bin)
      item2 = Item.create!(name: 'Item 2', bin: bin)
      other_bin = Bin.create!(valid_attributes)
      other_item = Item.create!(name: 'Item 3', bin: other_bin)

      items = bin.items_in_bin
      expect(items).to include(item1, item2)
      expect(items).not_to include(other_item)
    end

    it 'returns empty when bin has no items' do
      expect(bin.items_in_bin).to be_empty
    end
  end

  # Attachment handling
  describe 'bin pictures' do
    let(:bin) { Bin.create(valid_attributes) }

    it 'can have multiple attached pictures' do
      # Simulating file attachments
      file1 = fixture_file_upload('spec/fixtures/test_image1.jpg', 'image/jpeg')
      file2 = fixture_file_upload('spec/fixtures/test_image2.jpg', 'image/jpeg')
      
      bin.bin_pictures.attach(file1)
      bin.bin_pictures.attach(file2)

      expect(bin.bin_pictures).to be_attached
      expect(bin.bin_pictures.count).to eq(2)
    end

    it 'destroys attached pictures when bin is destroyed' do
      file = fixture_file_upload('spec/fixtures/test_image1.jpg', 'image/jpeg')
      bin.bin_pictures.attach(file)
      
      expect {
        bin.destroy
      }.to change(ActiveStorage::Attachment, :count).by(-1)
    end
  end

  # User association behavior
  describe 'user association' do
    let(:bin) { Bin.create(valid_attributes) }

    it 'increments user bins count when created' do
      expect {
        user.bins.create(valid_attributes.except(:user))
      }.to change { user.reload.bins_count }.by(1)
    end

    it 'decrements user bins count when destroyed' do
      bin # Create the bin
      expect {
        bin.destroy
      }.to change { user.reload.bins_count }.by(-1)
    end
  end

  # Dependent items behavior
  describe 'dependent items' do
    let(:bin) { Bin.create(valid_attributes) }
    
    before do
      Item.create(name: 'Test Item', user: user, bin: bin)
    end

    it 'maintains association with items' do
      expect(bin.items).not_to be_empty
      expect(bin.items.first.bin).to eq(bin)
    end

    it 'allows items to be reassigned before deletion' do
      new_bin = Bin.create(valid_attributes)
      bin.items.update_all(bin_id: new_bin.id)
      expect(bin.reload.items).to be_empty
      expect(new_bin.items).not_to be_empty
    end
  end
end
# helped by cursor