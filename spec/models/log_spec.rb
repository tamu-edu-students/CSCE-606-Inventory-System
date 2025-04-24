require 'rails_helper'

RSpec.describe Log, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }
  
  describe "validations" do
    it { should belong_to(:user) }
    it { should belong_to(:item).optional }
    it { should belong_to(:bin).optional }
    it { should validate_presence_of(:action_type) }
    it { should validate_presence_of(:action_date) }
  end

  describe "scopes" do
    it "filters logs by date range" do
      location = create(:location, user: user)
      bin = create(:bin, user: user, location: location)
      
      # Create logs on different dates
      travel_to 2.days.ago do
        item = create(:item, user: user, bin: bin, location: location)
        Log.log_item_action(user, item, 'create', "Created item")
      end
      
      travel_to 1.day.ago do
        item = create(:item, user: user, bin: bin, location: location)
        Log.log_item_action(user, item, 'create', "Created item")
      end

      start_date = 2.days.ago.beginning_of_day
      end_date = Time.current
      
      filtered_logs = Log.date_range(start_date, end_date)
      expect(filtered_logs.count).to eq(2)
    end
  end

  describe "log creation" do
    let(:location) { create(:location, user: user) }
    let(:bin) { create(:bin, user: user, location: location) }
    let(:item) { create(:item, user: user, bin: bin, location: location) }

    it "creates item action logs" do
      log = Log.log_item_action(
        user,
        item,
        'create',
        "Created new item"
      )
      
      expect(log).to be_persisted
      expect(log.user).to eq(user)
      expect(log.item).to eq(item)
      expect(log.bin).to eq(bin)
      expect(log.action_type).to eq('create')
      expect(log.description).to eq("Created new item")
    end

    it "creates bin action logs" do
      log = Log.log_bin_action(
        user,
        bin,
        'update',
        "Updated bin location"
      )
      
      expect(log).to be_persisted
      expect(log.user).to eq(user)
      expect(log.bin).to eq(bin)
      expect(log.action_type).to eq('update')
      expect(log.description).to eq("Updated bin location")
    end

    it "tracks location changes" do
      new_location = create(:location, user: user)
      old_location_id = item.location_id.to_s
      
      # Update item's location
      item.update(location: new_location)
      
      log = Log.last
      expect(log.from_location).to eq(old_location_id)
      expect(log.to_location).to eq(new_location.id.to_s)
    end
  end
end
