# factory bots requires
require 'factory_bot_rails' 
World(FactoryBot::Syntax::Methods)

Given('I am a logged-in user on the dashboard') do
  @user = User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!')

  visit new_user_session_path
  fill_in "user[email]", with: "test@example.com"
  fill_in "user[password]", with: "Password1!"
  click_button "Login"

  expect(page).to have_current_path(dashboard_path) # Ensure login redirects correctly
end

Given("I have bins with names {string} and {string}") do |bin1_name, bin2_name|
  create(:bin, name: bin1_name, category_name:"tech", user: @user, location: @location)  # Create first bin
  create(:bin, name: bin2_name, category_name: "tech", user: @user, location: @location)  # Create second bin
end


Given("I have items with names {string} and {string} on bin {string}") do |item1_name, item2_name, bin_name|
  # Find the bin by its name
  bin = Bin.find_by(name: bin_name)
  create(:item, name: item1_name, user: @user, location: @location, bin: bin)  # Create first item
  create(:item, name: item2_name, user: @user, location: @location, bin: bin)  # Create first item
end

When('I enter {string} in the bins search bar') do |search_term|
  fill_in 'search-inventory', with: search_term
end

And('I click the bins search button') do
  click_button 'search-inventory-btn'
end

Then('I should see bins matching {string}') do |query|
  expect(page).to have_content(query)  
end

Then('I should see categories matching {string}') do |query|
  expect(page).to have_content(query)  
end

Then('I should see a message {string}') do |query|
  expect(page).to have_content(query)  
end

When('I enter {string} in the items search bar') do |search_term|
  fill_in 'search-items', with: search_term
end

And('I click the items search button') do
  click_button 'search-items-btn'
end

Then('I should see items matching {string}') do |query|
  expect(page).to have_content(query)  
end

Then('I should be redirected to the log-in page') do
  expected_login_path = Rails.application.routes.url_helpers.new_user_session_path  # Correct path for login
  expect(page).to have_current_path(expected_login_path, wait: 5)
  #expect(current_path).to eq(expected_login_path) # Check if user was redirected to login
end