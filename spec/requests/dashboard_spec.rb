require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers
  let(:user) { create(:user) }

  describe "GET /dashboard" do
    context "when logged in" do
      before(:each) do
        Rails.application.reload_routes!
        sign_in user
      end

      it "returns http success" do
        get dashboard_path
        expect(response).to have_http_status(:success)
        puts "✅ Test Passed: GET /dashboard"
      end
    end

    context "when not logged in" do
      it "redirects to the login page with alert message" do
        get dashboard_path
        expect(response).to redirect_to("/users/sign_in")
        follow_redirect!
    
        expect(response.body).to include("You need to sign in or sign up before continuing.")
        puts "✅ Test Passed: Redirect to login page with Devise alert"
      end
    end
    
  end
end
