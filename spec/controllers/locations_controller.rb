require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  let(:user) { create(:user) }
  let!(:location1) { create(:location, name: "Tech Lab", user: user) }
  let!(:location2) { create(:location, name: "Living Room", user: user) }
  let!(:location3) { create(:location, name: "Office Desk", user: user) }

  before do
    Rails.application.reload_routes!
    sign_in user
  end

  describe "GET #index" do
    context "without search params" do
      it "assigns all locations to @locations" do
        get :index
        expect(assigns(:locations)).to match_array([location1, location2, location3])
        puts "✅ Test Passed: GET /index Location Controller"
      end
    end

    context "with search params" do
      it "assigns filtered locations to @locations" do
        get :index, params: { name: "Tech" }
        expect(assigns(:locations)).to match_array([location1])
        puts "✅ Test Passed: Search params"
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new location" do
        expect {
          post :create, params: { location: { name: "New Location" } }
        }.to change(Location, :count).by(1)
        expect(flash[:notice]).to eq("Location created successfully!")
        expect(response).to redirect_to(locations_path)
        puts "✅ Test Passed: POST Create Location Controller"
      end
    end

    context "with invalid attributes" do
      it "does not create a new location" do
        expect {
          post :create, params: { location: { name: "" } }
        }.not_to change(Location, :count)
        expect(flash.now[:alert]).to eq("Failed to create location")
        expect(response).to redirect_to(locations_path)
        puts "✅ Test Passed: Invalid Attributes"
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the location" do
        patch :update, params: { id: location1.id, location: { name: "Updated Location" } }
        location1.reload
        expect(location1.name).to eq("Updated Location")
        expect(flash[:notice]).to eq("Location updated successfully!")
        expect(response).to redirect_to(locations_path)
        puts "✅ Test Passed: PATCH Update Location Controller"
      end
    end

    context "with invalid attributes" do
      it "does not update the location" do
        patch :update, params: { id: location1.id, location: { name: "" } }
        location1.reload
        expect(location1.name).to eq("Tech Lab")
        expect(flash[:alert]).to eq("Failed to update location")
        expect(response).to redirect_to(locations_path)
        puts "✅ Test Passed: Invalid Atributes"
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the location" do
      expect {
        delete :destroy, params: { id: location1.id }
      }.to change(Location, :count).by(-1)
      expect(flash[:notice]).to eq("Location deleted successfully!")
      expect(response).to redirect_to(locations_path)
      puts "✅ Test Passed: DELETE  Location Controller"
    end

    it "handles errors during deletion" do
      allow_any_instance_of(Location).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: location1.id }
      expect(flash[:alert]).to eq("Failed to delete location")
      expect(response).to redirect_to(locations_path)
      puts "✅ Test Passed: handle error during deletion"
    end
  end
end