require 'rails_helper'

RSpec.describe "Bin Sharing", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:owner)        { create(:user) }
  let(:friend)       { create(:user) }
  let(:location)     { create(:location, user: owner) }
  let(:shareable_bin) { create(:bin, user: owner, location: location, is_shared: true) }
  let(:unshareable_bin) { create(:bin, user: owner, location: location, is_shared: false) }

  before do
    Rails.application.reload_routes!
    sign_in owner
  end

  describe "POST /bins/:id/share" do
    it "redirects with alert if bin is not shareable" do
      post update_sharing_bin_path(unshareable_bin), params: { shared_with_ids: [friend.id] }

      expect(response).to redirect_to(edit_bin_path(unshareable_bin))
      follow_redirect!
      expect(response.body).to include("please enable the &quot;Allow sharing with friends&quot; option")
      puts "✅ Test Passed: Cannot share if bin is not shareable"
    end

    it "updates shared users successfully" do
      post update_sharing_bin_path(shareable_bin), params: { shared_with_ids: [friend.id] }

      expect(response).to redirect_to(bin_path(shareable_bin))
      follow_redirect!
      expect(response.body).to include("Bin sharing updated successfully.")

      expect(shareable_bin.shared_with_users.reload).to include(friend)
      puts "✅ Test Passed: Shared bin with new user"
    end

    it "clears existing shares if none are passed" do
      # Pre-populate share
      shareable_bin.share_with(friend)
      expect(shareable_bin.shared_with_users).to include(friend)

      post update_sharing_bin_path(shareable_bin), params: {}

      expect(response).to redirect_to(bin_path(shareable_bin))
      expect(shareable_bin.shared_with_users.reload).to be_empty
      puts "✅ Test Passed: Cleared existing shares when none passed"
    end
  end
end
