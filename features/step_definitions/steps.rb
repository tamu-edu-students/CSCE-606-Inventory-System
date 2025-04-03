Given('a user exists with email {string} and password {string}') do |email, password|
  User.create!(
    name: "Rafael",  # Placeholder name for the user
    email: email,
    password: password,
    password_confirmation: password
  )
end

Given("some user exists with email {string} and password {string}") do |email, password|
  User.find_or_create_by(email: email) do |user|
    user.password = password
    user.password_confirmation = password
  end
end

When('I visit the login page') do
  visit new_user_session_path
end

When('I fill in {string} with {string}') do |field, value|
  case field
  when "Name"
    fill_in "user[name]", with: value
  when "Email"
    find("input[name='user[email]']", visible: true).set(value)
  when "Password"
    fill_in "user[password]", with: value
  when "Password confirmation"
    fill_in "user[password_confirmation]", with: value
  else
    fill_in field, with: value
  end
end


When('I press {string}') do |button|
  click_button button
end

Given('I am on the sign-up page') do
  visit signup_path
end

Then('I should see {string}') do |message|
  expect(page.all(:xpath, "//*[contains(text(), '#{message}')]").size)
end

Then('I should be on the login page') do
  expect(current_path).to eq(new_user_session_path)
end


# for updating bin
Given('I am logged in as {string} with password {string}') do |email, password|
  @user = User.create!(email: email, password: password, name: "Test User")

  visit new_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
  @bin = @user.bins.create!(name: "bin1", location: "Garage", category_name: "Misc")
  expect(page).to have_content("Signed in successfully") # Adjust based on your app's flash message
end


When('I visit the edit page for {string}') do |bin_name|
  bin = Bin.find_by(name: bin_name)
  visit edit_bin_path(bin)

  expect(page).to have_content("Editing bin") # Adjust based on your edit page title
end

When('I fill in the bin name with {string}') do |new_name|
  fill_in "Name", with: new_name
end

Then('I should see {string} on the bins list') do |updated_bin_name|
  visit bins_path # Ensure we are on the bins index page
  expect(page).to have_content(updated_bin_name)
end

# adding an item
Given('a bin named {string} exists') do |bin_name|
  @bin = Bin.create!(name: bin_name, location: "Garage", category_name: "Misc", user: @user)
end

When('I visit the new item page') do
  visit new_item_path # Make sure this route exists in your `config/routes.rb`
end

When('I ended selecting {string} from {string}') do |option, field|
  fill_in field, with: option
end

When('I fill in the item field {string} with {string}') do |field, value|
  fill_in "item_#{field.downcase}", with: value
  sleep 1
end

Then('I should be redirected to the item details page') do
  expect(current_path).to eq("/items")  # Exact match
end

Given('I have a bin named {string}') do |bin_name|
  location = Location.find_or_create_by!(name: "Garage", user: @user)  # ✅ Ensure Location object
  @bin = Bin.create!(name: bin_name, user: @user, location: location, category_name: "Misc")
end


When('I visit the login page s1') do
  visit login_path
end

When('I fill in {string} with {string} s1') do |field, value|
  case field
  when "Name"
    fill_in "user[name]", with: value
  when "Email"
    fill_in "user[email]", with: value
  when "Password"
    fill_in "user[password]", with: value
  when "Password confirmation"
    fill_in "user[password_confirmation]", with: value
  else
    fill_in field, with: value
  end
end

When('I select {string} from the bin dropdown') do |bin_name|
  find('select#item_bin_id', wait: 5) # Wait for the dropdown to appear
  select bin_name, from: 'item_bin_id'
end

Given('a location {string} exists') do |location_name|
  @location = FactoryBot.create(:location, name: location_name, user: @user)
end
