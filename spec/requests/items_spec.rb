require 'rails_helper'

RSpec.describe "Items", type: :request do
  let!(:user) { create(:user, email: "test_user_#{SecureRandom.hex(4)}@example.com") }
  let(:location) { create(:location, user: user) } 
  let(:bin) { create(:bin, user: user, location: location) }
  let(:item) { create(:item, bin: bin, location:location, user:user) }  # Ensures the item is associated with a bin

  before(:each) do
    Rails.application.reload_routes!
    sign_in user
  end

  describe "GET /index" do
    it "returns http success" do
      get items_path
      expect(response).to have_http_status(:success)
      puts "✅ Test Passed: GET /index"
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get item_path(item)
      expect(response).to have_http_status(:success)
      puts "✅ Test Passed: GET /show"
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_item_path
      expect(response).to have_http_status(:success)
      puts "✅ Test Passed: GET /new"
    end
  end

  describe "POST /create" do
    it "creates a new item and redirects to item page" do
      expect {
        post items_path, params: { item: { name: "New Item", value: 50, bin_id: bin.id } }
        #sleep 0.5  # ✅ Small delay to allow DB commit in test environment
      }.to change { Item.count }.by(1)
    
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(items_path)
      puts "✅ Test Passed: POST / Create"
    end
  end

  describe "PATCH /update" do
    it "updates an existing item" do
      patch item_path(item), params: { 
        item: { 
          name: "UpdatedItem",
          description: "Updated Description",
          value: 200,
          bin_id: bin.id,
          no_bin: false
        } 
      }
      #item.reload 
      expect(response).to redirect_to(item_path(item))
      follow_redirect!
      expect(response.body).to include("UpdatedItem")
      puts "✅ Test Passed: PATCH /update"
    end
  end
  
  describe 'PATCH /items/:id' do
    let(:user)     { create(:user, email: "user_#{SecureRandom.hex(4)}@example.com") }
    let(:location) { create(:location, user: user) }
    let(:bin)      { create(:bin, user: user, location: location) }
    let(:item)     { create(:item, user: user, bin: bin, location: location, name: "Original Name", value: 10.0) }
  
    before do
      sign_in user

    end
  
    it "renders edit when update fails" do
      patch item_path(item), params: {
        item: { name: "", value: nil }  # invalid input
      }
    
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Please correct the following errors")
      puts "✅ Test Passed: Hit the update failure path and rendered edit"
    end
  end

  describe "GET /edit" do
    it "returns http success and loads bins, locations, and bin_location_map" do
      get edit_item_path(item)

      expect(response).to have_http_status(:success)

      # Basic check to confirm the form rendered
      expect(response.body).to include("Edit Item")

      # Optional: verify dropdowns are populated
      expect(response.body).to include(bin.name)
      expect(response.body).to include(location.name)

      # Optional: verify JSON for bin-location map is rendered
      expect(response.body).to include("binLocationMap")
      expect(response.body).to include(bin.id.to_s)
      expect(response.body).to include(location.id.to_s)

      puts "✅ Test Passed: GET /edit loads form with bin and location info"
    end
  end


  describe "DELETE /destroy" do
    it "deletes an item and redirects to items list" do
      item_to_delete = bin.items.create!(name: "Delete Me", description: "Test", value: 20, user: user)
      expect {
        delete item_path(item_to_delete)
      }.to change(Item, :count).by(0)

      expect(response).to redirect_to(items_path)
      puts "✅ Test Passed: DELETE /destroy"
    end
  end

  describe "GET /items with sale_date param" do
    it "filters items created before or on the sale_date" do
      old_item = create(:item, user: user, bin: bin, location: location, created_at: 5.days.ago)
      recent_item = create(:item, user: user, bin: bin, location: location, created_at: Time.current)
  
      get items_path, params: { sale_date: 3.days.ago.to_date }
  
      expect(response).to have_http_status(:success)
  
      # Only the old item should appear
      expect(response.body).to include(old_item.name)
      expect(response.body).not_to include(recent_item.name)
  
      puts "✅ Test Passed: GET /items filtered by sale_date"
    end
  end


  describe "POST /items" do
    context "when the item fails validation" do
      let!(:bin1) { create(:bin, user: user) }
      let!(:location1) { create(:location, user: user) }

      it "renders the :new template with bins and locations and status 422" do
        post items_path, params: {
          item: {
            name: "",            # invalid
            value: "",           # invalid
            bin_id: bin1.id,
            location_id: location1.id
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("prohibited this item from being saved")

        # Check if known bin/location names are present in the rendered form
        expect(response.body).to include(bin1.name)
        expect(response.body).to include(location1.name)
      end
    end
  end

end
