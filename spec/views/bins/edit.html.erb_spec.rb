require 'rails_helper'

RSpec.describe "bins/edit", type: :view do
  let(:user) { create(:user) }
  let(:location) { create(:location) }
  let(:bin) { create(:bin, user: user, location: location, category_name: "Tools") }
  let(:categories) { ["Tools", "Clothing", "Electronics"] }

  before do
    Rails.application.reload_routes!
    assign(:bin, bin)
    assign(:categories, categories)
    assign(:locations, [location])
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders the edit bin form" do
    render

    # Check form and fields
    expect(rendered).to have_selector("form")
    expect(rendered).to have_field("bin_name", with: bin.name)
    expect(rendered).to have_field("bin[category_name]", with: bin.category_name)
    expect(rendered).to have_select("bin_location_id", with_options: [location.name])
  end
end
