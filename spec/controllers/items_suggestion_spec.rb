require 'rails_helper'

RSpec.describe "Item Suggestions", type: :system do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }

  let!(:item) do
    create(:item,
      user: user,
      name: "Wrench",
      description: "Handy tool",
      value: 20.0,
      bin: create(:bin, user: user, name: "Toolbox", category_name: "Tools", location: location),
      location: location
    )
  end

  before do
    Rails.application.reload_routes!
    driven_by(:selenium_chrome_headless)
    sign_in user
  end

  it "shows item suggestions when typing into search box" do
    visit dashboard_path
    expect(page).to have_content("Welcome to Your Inventory")

    fill_in "search-items", with: "Wr"
    sleep 1.5 # wait for debounce and async suggestion

    within("#item-suggestions") do
      expect(page).to have_content("Wrench")
    end
  end
end
