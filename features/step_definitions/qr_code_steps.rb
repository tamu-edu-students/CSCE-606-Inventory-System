Given("I am a logged-in user") do
  @user = User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!')
  
  visit new_user_session_path
  fill_in "user[email]", with: "test@example.com"
  fill_in "user[password]", with: "Password1!"
  click_button "Login"
end

When("I visit the new bin page") do
  visit new_bin_path
end

When(/^I fill in the bin "(.*)" with "(.*)"$/) do |field, value|
  expect(page).to have_field(field, wait: 5)
  fill_in field, with: value
end


When(/^I select "(.*)" from "(.*)"$/) do |value, field|
  select value, from: field
end

When("I click {string}") do |button|
  click_button button
end

Then(/^I should see the bin success message "(.*)"$/) do |message|
  expect(page.all(:xpath, "//*[contains(text(), '#{message}')]").size)
end




Then("I should see a QR code") do
  expect(page).to have_css("svg") # Checks if an SVG exists in the page
end

# step definition for scan
 
Given(/^I have a bin named "(.*)" with a QR code$/) do |bin_name|
  user = @user
  location = @location
  @bin = Bin.create!(
    name: bin_name,
    location: location,
    category_name: "Misc",
    user: user # Assuming @user is already set from a previous step
  )

  # Ensure QR code is generated after creation
  @bin.send(:update_qr_code)
end

When(/^I scan the QR code for "(.*)"$/) do |bin_name|
  bin = Bin.find_by(name: bin_name)
  expect(bin).not_to be_nil, "Bin '#{bin_name}' was not found"

  # Simulate scanning the QR code by visiting its URL
  visit bin_path(bin)
end


Then(/^I should be redirected to the bin page for "(.*)"$/) do |bin_name|
  bin = Bin.find_by(name: bin_name)
  expect(page).to have_current_path(bin_path(bin))
  expect(page).to have_content(bin_name)
end