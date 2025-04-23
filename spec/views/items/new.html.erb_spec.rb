require 'rails_helper'

RSpec.describe "items/new", type: :view do
  let(:user) { create(:user) }
  let(:location) { create(:location) }
  let(:bin) { create(:bin, user: user, location: location) }
  let(:item) { build(:item, user: user) }

  before do
    Rails.application.reload_routes!
    assign(:item, item)
    assign(:locations, [location])
    assign(:bins, [bin])
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders new item form" do
    render
    expect(rendered).to have_selector("form")
    expect(rendered).to have_select("binSelect", with_options: [bin.name])
    expect(rendered).to have_select("locationSelect", with_options: [location.name])
  end
end
