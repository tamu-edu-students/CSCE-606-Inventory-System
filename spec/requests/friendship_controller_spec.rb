require 'rails_helper'

RSpec.describe "Friendships", type: :request do
  let!(:user) { create(:user, email: "user_#{SecureRandom.hex(4)}@example.com") }
  let!(:friend) { create(:user, email: "friend_#{SecureRandom.hex(4)}@example.com") }

  before do
    Rails.application.reload_routes!
    sign_in user
  end

  describe "GET /friendships" do
    it "shows the friends list" do
      get friendships_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Friends").or include("No friends yet")
    end
  end

  describe "POST /friendships" do
    context "when friend exists" do
      it "creates a new friendship" do
        expect {
          post friendships_path, params: { email: friend.email }
        }.to change(Friendship, :count).by(1)

        expect(response).to redirect_to(friendships_path)
        follow_redirect!
        expect(response.body).to include("Successfully added")
      end
    end

    context "when friend email is invalid" do
      it "sets an alert flash" do
        post friendships_path, params: { email: "notfound@example.com" }

        expect(response).to redirect_to(friendships_path)
        follow_redirect!
        expect(response.body).to include("User not found")
      end
    end
  end

  describe "DELETE /friendships/:id" do
    let!(:friendship) { user.friendships.create!(friend: friend) }

    it "removes a friendship" do
      expect {
        delete friendship_path(friendship)
      }.to change(Friendship, :count).by(-1)

      expect(response).to redirect_to(friendships_path)
      follow_redirect!
      expect(response.body).to include("Removed #{friend.email}")
    end
  end
end
