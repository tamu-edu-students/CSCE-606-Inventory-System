require 'rails_helper'

RSpec.describe "SharedBins", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:owner)   { create(:user) }
  let(:friend)  { create(:user) }
  let(:location) { create(:location, user: owner) }
  let(:bin)     { create(:bin, user: owner, location: location, is_shared: true) }

  before do
    Rails.application.reload_routes!
    sign_in owner
  end

  describe "POST /bins/:bin_id/shared_bins" do
    context "when sharing with a valid friend" do
      it "creates a shared bin and redirects" do
        post bin_shared_bins_path(bin), params: { shared_with_id: friend.id }

        expect(response).to redirect_to(share_bin_path(bin))
        follow_redirect!
        expect(response.body).to include("Bin shared successfully")
        expect(bin.shared_with_users).to include(friend)
        puts "✅ Test Passed: Bin shared"
      end
    end

    context "when sharing fails (e.g. self-sharing)" do
      it "displays an error" do
        post bin_shared_bins_path(bin), params: { shared_with_id: owner.id }

        expect(response).to redirect_to(share_bin_path(bin))
        follow_redirect!
        expect(response.body).to include("Shared with can&#39;t be the same as bin owner")
        puts "✅ Test Passed: Prevented self-sharing"
      end
    end
  end

  describe "DELETE /bins/:bin_id/shared_bins/:id" do
    let!(:shared_record) { bin.shared_bins.create(shared_with: friend) }

    it "removes access and redirects" do
      delete bin_shared_bin_path(bin, shared_record)

      expect(response).to redirect_to(share_bin_path(bin))
      follow_redirect!
      expect(response.body).to include("Access removed successfully")
      expect(bin.shared_with_users.reload).not_to include(friend)
      puts "✅ Test Passed: Access removed"
    end

    it "handles failure to destroy (simulate failure)" do
      # Simulate failure by mocking
      allow_any_instance_of(SharedBin).to receive(:destroy).and_return(false)

      delete bin_shared_bin_path(bin, shared_record)

      expect(response).to redirect_to(share_bin_path(bin))
      follow_redirect!
      expect(response.body).to include("Failed to remove access")
      puts "✅ Test Passed: Handles destroy failure"
    end
  end
end
