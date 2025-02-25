require 'rails_helper'

RSpec.feature "Session Logs", type: :feature do
  let(:user) { create(:user) }  # Test user
  
  before do
    login_as(user, scope: :user)  # Simulate user login
  end

  scenario "User login creates a session record" do
    visit log_history_path  # Visit log page to verify session logs
    
    # Check if session log exists
    expect(page).to have_content("Session Log History")

    # Ensure at least one session entry is recorded
    expect(Session.where(user: user).count).to be > 0
  end

  scenario "Session updates when user adds an item" do
    visit new_item_path  # Navigate to add item page
    fill_in "Name", with: "Test Item"
    fill_in "Value", with: 10
    click_button "Create Item"

    visit log_history_path  # Check session logs
    
    # Verify the session recorded the item addition
    expect(page).to have_content("Added Item: Test Item")
  end

  scenario "Session updates when user logs out" do
    visit dashboard_path
    click_link "Logout"  # Simulate logout

    visit log_history_path
    last_session = Session.where(user: user).last

    # Verify logout time is recorded
    expect(last_session.logout_time).not_to be_nil
    expect(page).to have_content("Logged out at")
  end
end
