require 'rails_helper'

RSpec.describe Bin, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let(:valid_attributes) do
    {
      name: 'Storage Box',
      user: user,
      location: location,
      category_name: "Misc"
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
      puts "✅ Test Passed: requires name"
    end

    it 'belongs to a user' do
      bin = Bin.new(valid_attributes.merge(user: nil))
      expect(bin).not_to be_valid
      puts "✅ Test Passed: belongs to user"
    end


    # QR Code is generated after creation
    it 'generates a QR code upon creation' do
      bin = Bin.create!(valid_attributes)
      expect(bin.qr_code).not_to be_nil
      puts "✅ Test Passed: generated qr code upon creation"
    end

    # QR Code contains the correct URL
    it 'has a valid QR code containing the correct bin URL' do
      bin = Bin.create!(valid_attributes)
      expected_url = "http://127.0.0.1:3000/bins/#{bin.id}"
      #call method that has the URL
      expect(bin.send(:qr_code_data)).to eq(expected_url) # Compare it with the generated QR code
      puts "✅ Test Passed: has a valid QR code"
    end
  end

  # Associations
  describe 'associations' do
    let(:bin) { Bin.create(valid_attributes) }

    it 'belongs to a user with counter cache' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:counter_cache]).to include(active: true)
      puts "✅ Test Passed: Associations - belong to user"
    end

    it 'has many items' do
      association = described_class.reflect_on_association(:items)
      expect(association.macro).to eq :has_many
      puts "✅ Test Passed: Association, has many items"
    end


    # QR Code - should only work for correct user
    it 'ensures QR code belongs to the correct user' do
      bin = Bin.create!(valid_attributes)
      expect(bin.user_id).to eq(user.id) # insures correct ownership
      puts "✅ Test Passed: Association: Ensure QR code belongs to correct user"
    end
  end

  # Instance Methods
  describe '#items_in_bin' do
    let(:bin) { Bin.create!(valid_attributes) }
    
    it 'returns items belonging to the bin' do
      item1 = Item.create!(name: 'Item 1', bin: bin, value: 10.0, user:user)
      item2 = Item.create!(name: 'Item 2', bin: bin, value: 20.0, user:user)
      other_bin = Bin.create!(valid_attributes)
      other_item = Item.create!(name: 'Item 3', bin: other_bin, value: 15.0, user:user)

      items = bin.items_in_bin
      expect(items).to include(item1, item2)
      expect(items).not_to include(other_item)
      puts "✅ Test Passed: Intance Method, return item belonging to bin"
    end

    it 'returns empty when bin has no items' do
      expect(bin.items_in_bin).to be_empty
      puts "✅ Test Passed: Intance Method, return empty when bin has no item"
    end
  end

  # User association behavior
  describe 'user association' do
    let(:bin) { Bin.create(valid_attributes) }

    it 'increments user bins count when created' do
      expect {
        user.bins.create(valid_attributes.except(:user))
      }.to change { user.reload.bins_count }.by(1)
      puts "✅ Test Passed: User association, increment user bins when created"
    end

    it 'decrements user bins count when destroyed' do
      bin # Create the bin
      expect {
        bin.destroy
      }.to change { user.reload.bins_count }.by(-1)
      puts "✅ Test Passed: User association, decrements user bins count when destroyed"
    end
  end

  # Dependent items behavior
  describe 'dependent items' do
    let(:bin) { Bin.create(valid_attributes) }
    
    before do
      Item.create!(name: 'Item 1', bin: bin, value: 10.0, user:user)
    end

    it 'maintains association with items' do
      expect(bin.items).not_to be_empty
      puts "✅ Test Passed: bin is not empty"
      expect(bin.items.first.name).to eq('Item 1')
      puts "✅ Test Passed: maintain association with items"
    end

    it 'allows items to be reassigned before deletion' do
      new_bin = Bin.create(valid_attributes)
      bin.items.update_all(bin_id: new_bin.id)
      expect(bin.reload.items).to be_empty
      expect(new_bin.items).not_to be_empty
      puts "✅ Test Passed: allows items to be reassigned before deletion"
    end
  end
end
# helped by cursor