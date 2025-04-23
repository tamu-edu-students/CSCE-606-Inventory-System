require 'rails_helper'

RSpec.describe "Bin Suggestions", type: :system do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let!(:bin) { create(:bin, user: user, name: "Bookshelf", category_name: "Books", location: location) }

  before do
    Rails.application.reload_routes!
    driven_by(:selenium_chrome_headless) # or :selenium_chrome
    sign_in user
  end

  it "shows bin and category suggestions when typing into search box" do
    visit dashboard_path
    expect(page).to have_content("Welcome to Your Inventory")

    fill_in "search-inventory", with: "Bo"
    sleep 1.5 # simulate debounce and fetch delay

    within("#bin-suggestions") do
      expect(page).to have_content("Bookshelf")
      expect(page).to have_content("Books")
    end
  end
end
