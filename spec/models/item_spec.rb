require 'rails_helper'

RSpec.describe Item, type: :model do
  # Setup test data
  #let!(:user) { create(:user) }
  let!(:user) { create(:user, email: "test_user_#{SecureRandom.hex(4)}@example.com") }
  let!(:location) { create(:location, user: user) } 
  let!(:bin) { create(:bin, user: user, location: location) }
  let!(:valid_attributes) do
    {
      name: 'Test Item',
      description: 'A test item',
      value: 100.00,
      bin: bin,
      user: user,
      location: location
    }
  end

  # Validations
  describe 'validations' do
    it 'is valid with valid attributes' do
      item = Item.new(valid_attributes)
      expect(item).to be_valid
      puts "✅ Test Passed: Validation"
    end

    it 'requires a name' do
      item = Item.new(valid_attributes.merge(name: nil))
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
      puts "✅ Test Passed: Requires Name"
    end

    it 'validates value is greater than or equal to 0' do
      item = Item.new(valid_attributes.merge(value: -1))
      expect(item).not_to be_valid
      expect(item.errors[:value]).to include('must be greater than or equal to 0')
      puts "✅ Test Passed: Validates value is greater than or equal to 0"
    end
  end

  # Associations
  describe 'associations' do
    it 'belongs to a bin' do
      association = described_class.reflect_on_association(:bin)
      expect(association.macro).to eq :belongs_to
      puts "✅ Test Passed: Association"
    end

    it 'has many attached item pictures' do
      item = Item.new(valid_attributes)
      expect(item).to respond_to(:item_pictures)
      expect(item.item_pictures).to be_an_instance_of(ActiveStorage::Attached::Many)
      puts "✅ Test Passed: Has many attached item pictures"
    end
  end


  # CRUD operations
  describe 'CRUD operations' do
    describe 'create' do
      it 'creates a new item with valid attributes' do
        expect {
          Item.create(valid_attributes)
        }.to change(Item, :count).by(1)
      end

      it 'saves all provided attributes' do
        item = Item.create(valid_attributes)
        expect(item.name).to eq('Test Item')
        expect(item.description).to eq('A test item')
        expect(item.value).to eq(100.00)
        puts "✅ Test Passed: CRUD Save"
      end
    end

    describe 'read' do
      let!(:item) { Item.create(valid_attributes) }

      it 'retrieves an existing item' do
        found_item = Item.find(item.id)
        expect(found_item).to eq(item)
        puts "✅ Test Passed: CRUD Retrieve"
      end

      it 'retrieves items by storage location' do
        items = Item.where(location: location)
        expect(items).to include(item)
        puts "✅ Test Passed: CRUD retreive Storage"
      end

      it 'retrieves items by user' do
        items = user.items
        expect(items).to include(item)
        puts "✅ Test Passed: CRUD Retrieve items by user"
      end
    end

    describe 'update' do
      let!(:item) { Item.create(valid_attributes) }
      let!(:garage)  { FactoryBot.create(:location, name: 'Garage', user: user) }

      it 'updates the item attributes' do
        expect {
          item.update(name: 'New LED Lights', location: garage)
        }.to change { item.reload.name }.to('New LED Lights')
         .and change { item.reload.location.name }.to('Garage')
    
        puts "✅ Test Passed: CRUD UPDATE"
      end

      it 'moves item to a different bin' do
        new_bin = Bin.create(name: 'Storage Box 1', location: location)
        expect {
          item.update(bin: new_bin)
        }.to change { item.bin }.to(new_bin)
        puts "✅ Test Passed: Moves"
      end
    end

    describe 'delete' do
      let!(:item) { Item.create(valid_attributes) }

      it 'removes the item' do
        expect {
          item.destroy
        }.to change(Item, :count).by(-1)
      puts "✅ Test Passed: CRUD Delete"
      end

      it 'can be restored if accidentally deleted', if: Item.respond_to?(:with_deleted) do
        item.destroy
        expect {
          item.restore
        }.to change(Item, :count).by(1)
      puts "✅ Test Passed: CRUD Destroy"
      end
    end
  end
end

# helped by cursor