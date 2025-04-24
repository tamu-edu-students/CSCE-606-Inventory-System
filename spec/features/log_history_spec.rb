require 'rails_helper'

RSpec.describe "Log History", type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  scenario "User views their log history" do
    location = create(:location, user: user, name: "Garage")
    bin = create(:bin, user: user, location: location, name: "Tools")
    item = create(:item, 
      user: user, 
      bin: bin, 
      location: location, 
      name: "Hammer",
      value: 29.99)

    visit "/log-history"

    expect(page).to have_content("Inventory Log History")
    expect(page).to have_content(item.name)
    expect(page).to have_content(bin.name)
    expect(page).to have_content("created")
  end

  scenario "User performs actions and sees them in log history" do
    location = create(:location, user: user, name: "Kitchen")
    bin = create(:bin, user: user, location: location, name: "Utensils")

    # Create an item
    visit "/items/new"
    fill_in "item[name]", with: "Fork Set"
    fill_in "item[value]", with: "15.99"
    select "Utensils", from: "item[bin_id]"
    click_button "Create Item"

    # Update the item
    item = Item.last
    visit "/items/#{item.id}/edit"
    fill_in "item[name]", with: "Silver Fork Set"
    click_button "Update Item"

    # Check log history
    visit "/logs"
    expect(page).to have_content("Fork Set")
    expect(page).to have_content("Silver Fork Set")
    expect(page).to have_content("created")
    expect(page).to have_content("updated")
  end

  scenario "Log entries are ordered by most recent first" do
    location = create(:location, user: user)
    bin = create(:bin, user: user, location: location)

    # Create items with explicit timestamps
    travel_to 2.days.ago do
      create(:item, user: user, bin: bin, location: location, name: "Item 0")
    end

    travel_to 1.day.ago do
      create(:item, user: user, bin: bin, location: location, name: "Item 1")
    end

    create(:item, user: user, bin: bin, location: location, name: "Item 2")

    visit "/logs"

    # Check that items appear in reverse chronological order
    within(".log-entries") do
      expect(all(".log-entry")[0]).to have_content("Item 2")
      expect(all(".log-entry")[1]).to have_content("Item 1")
      expect(all(".log-entry")[2]).to have_content("Item 0")
    end
  end
end
