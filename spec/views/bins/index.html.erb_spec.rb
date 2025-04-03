require 'rails_helper'

RSpec.describe "bins/index", type: :view do
  let(:user)     { create(:user) }
  let(:location) { create(:location, user: user) } 
  let(:bins)     { create_list(:bin, 2, user: user, location: location) }

  before(:each) do
    Rails.application.reload_routes!
  end

  before do
    assign(:bins, bins)
    allow(view).to receive(:current_user).and_return(user) # ✅ Mock user if navbar uses it
    render
  end

  it "renders a list of bin cards" do
    # Ensure the container exists
    expect(rendered).to have_css(".bins-container")

    # There should be 2 cards for 2 bins
    expect(rendered).to have_css(".bin-card", count: 2)

    # For each bin, check that name, location and category appear
    bins.each do |bin|
      expect(rendered).to include(bin.name)
      expect(rendered).to include(bin.location.name)
      expect(rendered).to include(bin.category_name)
    end

    puts "✅ Test Passed: view bins/index with card layout"
  end
end
