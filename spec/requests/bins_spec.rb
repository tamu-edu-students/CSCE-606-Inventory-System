require 'rails_helper'

RSpec.describe "/bins", type: :request do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user, name: "Garage") } 
  
  before(:each) do
    Rails.application.reload_routes!
    sign_in user
  end
  

  # Create a valid bin for testing
  let(:valid_attributes) do
    {
      name: "Test Bin",
      location_id: location.id,
      category_name: "Misc",
      user_id: user.id
    }
  end

  it "checks that bins_path exists" do
    Rails.application.reload_routes!
  end

  describe "GET /index" do 
    it "renders a successful response" do
      #get new_bin_path
      get "/bins"
      #get bin_path

      expect(response).to be_successful
      puts "✅ Test Passed: GET /index"
    end
  end
  

  # 🟢 NEW (GET /bins/new)
  describe "GET /new" do
    it "renders a successful response" do
      get new_bin_path
      #get "/bins"
      expect(response).to be_successful
      puts "✅ Test Passed: GET /new"
    end
  end

  # 🟢 SHOW (GET /bins/:id)
  describe "GET /show" do
    it "renders a successful response" do
      bin = Bin.create!(valid_attributes)
      get bin_path(bin)
      expect(response).to be_successful
      puts "✅ Test Passed: GET /show"
    end
  end

  # 🟢 EDIT (GET /bins/:id/edit)
  describe "GET /edit" do
    it "renders a successful response" do
      bin = Bin.create!(valid_attributes)
      get edit_bin_path(bin)
      expect(response).to be_successful
      puts "✅ Test Passed: GET /edit"
    end
  end

  # 🟢 CREATE (POST /bins)
  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Bin" do
        expect {
          post bins_path, params: { bin: valid_attributes }
        }.to change(Bin, :count).by(1)
      end

      it "redirects to the created bin" do
        post bins_path, params: { bin: valid_attributes }
        expect(response).to redirect_to(Bin.last)
        puts "✅ Test Passed: POST /bins"
      end
    end

    context "with invalid parameters" do
      it "does not create a new Bin" do
        expect {
          post bins_path, params: { bin: valid_attributes.merge(name: nil) }
        }.to_not change(Bin, :count)
        puts "✅ Test Passed: with invalid parameter"
      end

      it "renders a response with 422 status" do
        post bins_path, params: { bin: valid_attributes.merge(name: nil) }
        expect(response).to have_http_status(422)
        puts "✅ Test Passed: render 422 status"
      end
    end
  end

  # 🟢 UPDATE (PATCH /bins/:id)
  describe "PATCH /update" do
    let(:new_attributes) do
      {
        name: "Updated Bin",
      }
    end

    context "with valid parameters" do
      it "updates the requested bin" do
        bin = Bin.create!(valid_attributes)
        patch bin_path(bin), params: { bin: new_attributes }
        bin.reload
        expect(bin.name).to eq("Updated Bin")
        puts "✅ Test Passed: Update bin"
      end

      it "redirects to the bin" do
        bin = Bin.create!(valid_attributes)
        patch bin_path(bin), params: { bin: new_attributes }
        expect(response).to redirect_to(bin)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status" do
        bin = Bin.create!(valid_attributes)
        patch bin_path(bin), params: { bin: new_attributes.merge(name: nil) }
        expect(response).to have_http_status(422)
      end
    end
  end

  # 🟢 DELETE (DELETE /bins/:id)
  describe "DELETE /destroy" do
    it "destroys the requested bin" do
      bin = Bin.create!(valid_attributes)
      expect {
        delete bin_path(bin)
      }.to change(Bin, :count).by(-1)
    end

    it "redirects to the bins list" do
      bin = Bin.create!(valid_attributes)
      delete bin_path(bin)
      expect(response).to redirect_to(bins_path)
      puts "✅ Test Passed: Delete bin"
    end
  end

  describe "GET /bins with category filter" do
    it "returns bins matching the category" do
      Bin.create!(valid_attributes.merge(name: "Tool Bin", category_name: "Tools"))
      Bin.create!(valid_attributes.merge(name: "Toy Bin", category_name: "Toys"))
      
      get bins_path, params: { category: "Tools" }
  
      expect(response.body).to include("Tool Bin")
      expect(response.body).not_to include("Toy Bin")
      puts "✅ Test Passed: GET /bins with category filter"
    end
  end
  
  
end
