require 'rails_helper'

RSpec.describe "Profile Dropdown", type: :system do
  include Rails.application.routes.url_helpers
  
  before(:each) do
    Rails.application.reload_routes!
    driven_by(:selenium_chrome_headless)
  end

  let(:user) { create(:user, email: "test@example.com", password: "Password1!") }
  
  before do
    # Create some session history
    2.times do |i|
      Session.create!(
        user: user,
        login_time: (2 - i).hours.ago,
        logout_time: (2 - i - 1).hours.ago
      )
    end
    
    login_as(user, scope: :user)
    visit dashboard_path
    expect(page).to have_css('.navbar', wait: 5)
    puts "✅ Test Passed: showing user on nav-tab"
  end

  it "shows user information when clicking profile icon" do
    expect(page).to have_css("#profile-trigger", wait: 5)
    find("#profile-trigger").click
    
    within("#profile-dropdown-content") do
      expect(page).to have_content(user.email)
      expect(page).to have_content(Session.where(user: user).last.login_time.strftime("%Y-%m-%d %H:%M"))
      expect(page).to have_button("Logout")
      puts "✅ Test Passed: View Showing Logout button"
    end
  end

  it "closes dropdown when clicking outside" do
    expect(page).to have_css("#profile-trigger", wait: 5)
    find("#profile-trigger").click
    expect(page).to have_css("#profile-dropdown-content.active")
    
    page.find("body").click
    expect(page).not_to have_css("#profile-dropdown-content.active")
    puts "✅ Test Passed: Close when click outside"
  end

  it "logs out user when clicking logout button" do
    expect(page).to have_css("#profile-trigger", wait: 5)
    puts "✅ Test Passed: log out when user click logout"
    find("#profile-trigger").click
    
    within("#profile-dropdown-content") do
      # Use the new Turbo confirm dialog
      accept_confirm do
        click_button "Logout"
      end
    end

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content("Logged out successfully")
    puts "✅ Test Passed: redirtect to user login"
  end
end