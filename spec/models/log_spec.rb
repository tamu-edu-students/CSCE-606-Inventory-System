require 'rails_helper'

RSpec.describe Log, type: :model do
  let(:user) { create(:user) }
  
  describe "validations" do
    it { should belong_to(:user) }
    it { should validate_presence_of(:action) }
    it { should validate_presence_of(:item_name) }
  end

  describe "scopes" do
    it "orders logs by most recent first" do
      location = create(:location, user: user)
      bin = create(:bin, user: user, location: location)
      
      item1 = create(:item, user: user, bin: bin, location: location)
      sleep(1)
      item2 = create(:item, user: user, bin: bin, location: location)

      logs = user.logs
      expect(logs.first.item_name).to eq(item2.name)
      expect(logs.last.item_name).to eq(item1.name)
    end
  end

  describe "log creation" do
    let(:location) { create(:location, user: user) }
    let(:bin) { create(:bin, user: user, location: location) }
    
    it "creates valid log entries" do
      log = Log.new(
        user: user,
        action: "created",
        item_name: "Test Item",
        bin_name: bin.name,
        location_name: location.name
      )
      
      expect(log).to be_valid
      expect(log.save).to be true
    end

    it "includes bin and location information" do
      item = create(:item, user: user, bin: bin, location: location)
      log = Log.last
      
      expect(log.bin_name).to eq(bin.name)
      expect(log.location_name).to eq(location.name)
    end
  end
end