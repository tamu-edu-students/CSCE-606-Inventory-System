require 'rails_helper'

RSpec.describe "Logs", type: :request do
  let(:user) { create(:user) }
  
  before(:each) do
    sign_in user
  end

  describe "GET /log-history" do
    it "returns http success" do
      get log_history_path
      expect(response).to have_http_status(:success)
    end

    it "displays logs for the current user only" do
      # Create logs for current user
      other_user = create(:user)
      location = create(:location, user: user)
      bin = create(:bin, user: user, location: location)
      item = create(:item, user: user, bin: bin, location: location)
      
      # Create logs for other user
      other_location = create(:location, user: other_user)
      other_bin = create(:bin, user: other_user, location: other_location)
      other_item = create(:item, user: other_user, bin: other_bin, location: other_location)

      get log_history_path
      
      # Should see own logs
      expect(response.body).to include(item.name)
      expect(response.body).to include(bin.name)
      expect(response.body).to include(location.name)
      
      # Should not see other user's logs
      expect(response.body).not_to include(other_item.name)
      expect(response.body).not_to include(other_bin.name)
      expect(response.body).not_to include(other_location.name)
    end
  end

  describe "Log creation" do
    let(:location) { create(:location, user: user) }
    let(:bin) { create(:bin, user: user, location: location) }

    it "creates a log when an item is created" do
      expect {
        post items_path, params: {
          item: {
            name: "Test Item",
            value: 100,
            bin_id: bin.id,
            location_id: location.id
          }
        }
      }.to change(Log, :count).by(1)

      log = Log.last
      expect(log.user).to eq(user)
      expect(log.action).to eq("created")
      expect(log.item_name).to eq("Test Item")
    end

    it "creates a log when an item is updated" do
      item = create(:item, user: user, bin: bin, location: location)
      
      expect {
        patch item_path(item), params: {
          item: {
            name: "Updated Item"
          }
        }
      }.to change(Log, :count).by(1)

      log = Log.last
      expect(log.user).to eq(user)
      expect(log.action).to eq("updated")
      expect(log.item_name).to eq("Updated Item")
    end

    it "creates a log when an item is deleted" do
      item = create(:item, user: user, bin: bin, location: location)
      item_name = item.name
      
      expect {
        delete item_path(item)
      }.to change(Log, :count).by(1)

      log = Log.last
      expect(log.user).to eq(user)
      expect(log.action).to eq("deleted")
      expect(log.item_name).to eq(item_name)
    end
  end
end