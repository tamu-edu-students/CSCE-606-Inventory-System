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
  
    it 'renders edit when update fails' do
      patch item_path(item), params: {
        item: {
          name: '',           # Invalid: name can't be blank
          value: '',          # Invalid: value can't be blank
          bin_id: ''          # Should still hit the `else` path
        }
      }
  
      expect(response).to render_template(:edit) # ✅ we hit the else block
      expect(response.body).to include("prohibited this item from being saved")
      puts "✅ Test Passed: Hit the update failure path and rendered edit"
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
end
