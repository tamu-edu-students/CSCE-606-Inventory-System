require 'rails_helper'

RSpec.describe Bin, type: :model do
  let(:owner) { create(:user) }
  let(:shared_user) { create(:user) }
  let(:unrelated_user) { create(:user) }
  let(:location) { create(:location, user: owner) }

  describe "sharing functionality" do
    let(:bin) { create(:bin, user: owner, location: location, is_shared: true) }

    it "allows a bin to be shared with another user" do
      expect {
        bin.share_with(shared_user)
      }.to change { bin.shared_with_users.count }.by(1)

      expect(bin.shared_with_users).to include(shared_user)
    end

    it "does not share if is_shared is false" do
      bin.update(is_shared: false)
      expect(bin.share_with(shared_user)).to be_falsey
      expect(bin.shared_with_users).not_to include(shared_user)
    end

    it "removes user from shared list with unshare_with" do
      bin.share_with(shared_user)
      expect {
        bin.unshare_with(shared_user)
      }.to change { bin.shared_with_users.count }.by(-1)

      expect(bin.shared_with_users).not_to include(shared_user)
    end

    it "returns true for accessible_by? if user is owner" do
      expect(bin.accessible_by?(owner)).to be true
    end

    it "returns true for accessible_by? if bin is shared and user is shared_with" do
      bin.share_with(shared_user)
      expect(bin.accessible_by?(shared_user)).to be true
    end

    it "returns false for accessible_by? if user is unrelated and bin is not shared" do
      bin.update(is_shared: false)
      expect(bin.accessible_by?(unrelated_user)).to be false
    end
  end
end
