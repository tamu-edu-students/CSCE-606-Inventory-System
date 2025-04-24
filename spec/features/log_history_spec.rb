require 'rails_helper'

RSpec.feature "Log History", type: :feature do
  let(:user) { create(:user) }
  
  before do
    login_as(user, scope: :user)
  end

  scenario "User views their log history" do
    # Create some test data
    location = create(:location, user: user, name: "Garage")
    bin = create(:bin, user: user, location: location, name: "Tools")
    item = create(:item, 
      user: user, 
      bin: bin, 
      location: location, 
      name: "Hammer",
      value: 29.99)

    # Visit the log history page
    visit log_history_path

    # Verify the page content
    expect(page).to have_content("Inventory Log History")
    expect(page).to have_content(item.name)
    expect(page).to have_content(bin.name)
    expect(page).to have_content(location.name)
    expect(page).to have_content("created")
  end

  scenario "User performs actions and sees them in log history" do
    location = create(:location, user: user, name: "Kitchen")
    bin = create(:bin, user: user, location: location, name: "Utensils")

    # Create an item
    visit new_item_path
    fill_in "Name", with: "Fork Set"
    fill_in "Value", with: "15.99"
    select "Utensils", from: "Bin"
    select "Kitchen", from: "Location"
    click_button "Create Item"

    # Update the item
    item = Item.last
    visit edit_item_path(item)
    fill_in "Name", with: "Silver Fork Set"
    click_button "Update Item"

    # Delete the item
    visit items_path
    click_link "Delete"
    
    # Check log history
    visit log_history_path
    
    expect(page).to have_content("Fork Set")
    expect(page).to have_content("Silver Fork Set")
    expect(page).to have_content("created")
    expect(page).to have_content("updated")
    expect(page).to have_content("deleted")
  end

  scenario "Log entries are ordered by most recent first" do
    location = create(:location, user: user)
    bin = create(:bin, user: user, location: location)

    # Create multiple items
    3.times do |i|
      create(:item, 
        user: user, 
        bin: bin, 
        location: location, 
        name: "Item #{i}")
      sleep(1) # Ensure different timestamps
    end

    visit log_history_path

    # Check that items appear in reverse chronological order
    elements = page.all('.log-entry')
    expect(elements[0]).to have_content("Item 2")
    expect(elements[1]).to have_content("Item 1")
    expect(elements[2]).to have_content("Item 0")
  end
end