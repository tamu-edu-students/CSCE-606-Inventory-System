require 'rails_helper'

RSpec.feature "Locations", type: :feature do
  let(:user) { create(:user) }
  let!(:location1) { create(:location, name: "Tech Lab", user: user) }
  let!(:location2) { create(:location, name: "Living Room", user: user) }
  let!(:location3) { create(:location, name: "Office Desk", user: user) }

  before do
    Rails.application.reload_routes!
    sign_in user
    visit locations_path
  end

  scenario "renders the locations table" do
    expect(page).to have_content("Your Locations")
    expect(page).to have_content("Tech Lab")
    expect(page).to have_content("Living Room")
    expect(page).to have_content("Office Desk")
    puts "✅ Test Passed: Render location table"
  end
  
  scenario "typing in search input fetches results", js: true do
    find("#search-icon").click
    fill_in "search-input", with: "Tech Lab"
  
    expect(page).to have_content("Tech Lab")
    expect(page).not_to have_content("Living Room")
    puts "✅ Test Passed: Search input fetch right results"
  end

  scenario "adds a new location" do
    find(".addLocationBtn").click
    within("#addLocationModal") do
      fill_in "location[name]", with: "New Location"
    end
    click_button "Add Location"
    expect(page).to have_content("New Location")
    puts "✅ Test Passed: Add new location"
  end

  scenario "updates a location", js: true do
    find(".editLocationBtn", match: :first).click
    fill_in "location_name", with: "Updated Location"
    click_button "Update Location"
    expect(page).to have_content("Updated Location")
    puts "✅ Test Passed: Update Location"
  end

  scenario "deletes a location", js: true do
    find(".deleteLocationBtn", match: :first).click
    click_button "Yes"
    expect(page).not_to have_content(location1.name)
    puts "✅ Test Passed: Delete Location"
  end

end
