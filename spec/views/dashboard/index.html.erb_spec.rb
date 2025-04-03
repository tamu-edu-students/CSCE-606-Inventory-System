require 'rails_helper'

RSpec.describe "dashboard/index", type: :view do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    Rails.application.reload_routes!
  end

  before do
    # ✅ Simulate logged-in user
    allow(view).to receive(:current_user).and_return(user)

    # ✅ Stub route helpers
    allow(view).to receive(:bins_path).and_return("/bins")
    allow(view).to receive(:items_path).and_return("/items")

    render template: "dashboard/index", layout: "layouts/application"
  end

  it "displays the navigation links" do
    expect(rendered).to include("BINS")
    expect(rendered).to include("ITEMS")
    expect(rendered).to include("LOG")
    expect(rendered).to include("SALE")

    puts "✅ Test Passed: view nav links"
  end

  it "has search inputs and buttons" do
    expect(rendered).to have_selector("input[placeholder='Search by Bin/Category...']")
    expect(rendered).to have_button("Search", count: 5)
    expect(rendered).to have_selector("input[placeholder='Search Items...']")
    puts "✅ Test Passed: inputs and buttons"
  end

  it "has the 'Search by Location' button" do
    expect(rendered).to have_button("Search by Location")
    puts "✅ Test Passed: search by location button"
  end

  it "displays the user profile icon" do
    expect(rendered).to have_selector("div", text: user.email.first.upcase)
    puts "✅ Test Passed: display user profile icon"
  end
end
