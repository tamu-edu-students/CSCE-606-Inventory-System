require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers

  before(:each) do
    Rails.application.reload_routes!
  end

  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /signup" do
    let(:valid_user_params) do
      {
        user: {
          name: "New Tester",
          email: "test_user_#{SecureRandom.hex(4)}@example.com",
          password: "Password123!",
          password_confirmation: "Password123!"
        }
      }
    end

    it "creates a new user and redirects to login with flash notice" do
      expect {
        post signup_path, params: valid_user_params
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(new_user_session_path)
      follow_redirect!
      expect(response.body).to include("Account created successfully")
    end

    it "renders the :new template with errors if invalid" do
      post signup_path, params: { user: { name: "", email: "bad", password: "123", password_confirmation: "321" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("error") # can change to specific error message
    end
  end
end
