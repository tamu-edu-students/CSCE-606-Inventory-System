include Warden::Test::Helpers
Warden.test_mode!

Given("a location {string} exists") do |location_name|
  Location.create!(name: location_name)
end

Given("I am logged in as a user") do
  @user = User.create!(name: 'Test User', email: 'test1@example.com', password: 'Abc1234!')
  login_as(@user, scope: :user) 
  warden_user = Warden.test_mode!
  Rails.logger.info "🟢 Logged in as: #{@user.email}"
  Rails.logger.info "🟢 Current User in Warden: #{warden_user.inspect}"
  Rails.logger.info "🟢 Session Before Navigation: #{page.driver.browser.manage.all_cookies}"
end

Given("I am on the locations page") do
  visit locations_path
  warden_user = Warden.test_mode!
  Rails.logger.info "🟢 Session Cookies After Navigation: #{page.evaluate_script('document.cookie')}"
  Rails.logger.info "🟢 Session After Navigation: #{page.driver.browser.manage.all_cookies}"
  Rails.logger.info "🟢 Current User in Warden: #{warden_user.inspect}"
end

Then("I should see the text {string}") do |text|
  expect(page).to have_content(text)
end

Then("I should see a button {string}") do |button_text|
  expect(page).to have_button(button_text)
end

Then("I should see a link {string}") do |link_text|
  expect(page).to have_link(link_text)
end

Then("I should see a table with headers {string}") do |headers|
  headers.split(', ').each do |header|
    expect(page).to have_selector('th', text: header)
  end
end

When("I click the {string} button") do |button_text|
  click_button(button_text)
end

Then("I should see a modal with a form to add a new location") do
  expect(page).to have_selector('#addLocationModal', visible: true)
end

When("I fill in the location name and submit the form") do
  fill_in 'location_name', with: 'New Location'
  click_button 'Add Location'
end

Then("the new location should be added to the list") do
  puts "Current User: #{@user.email}" # ✅ Check user before assertion
  puts "Session Cookies: #{page.evaluate_script('document.cookie')}" # ✅ Check session persistence
  sleep 2
  puts page.body
  expect(page).to have_content("New Location")
end

When("I click the search icon in the {string} header") do |header|
  find("##{header.downcase.gsub(' ', '-')}-header .fa-search").click
end

Then("I should see an input field to search by name") do
  expect(page).to have_selector('input[type="text"]')
end

When("I enter a name in the search field") do
  fill_in 'search', with: 'Existing Location'
end

Then("the locations table should be filtered to show only matching locations") do
  expect(page).to have_content('Existing Location')
end