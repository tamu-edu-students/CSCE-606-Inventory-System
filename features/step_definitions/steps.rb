Given('a user exists with email {string} and password {string}') do |email, password|
  User.create!(
    name: "Rafael",  # Placeholder name for the user
    email: email,
    password: password,
    password_confirmation: password
  )
end

When('I visit the login page') do
  visit login_path
end

When('I fill in {string} with {string}') do |field, value|
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

When('I press {string}') do |button|
  click_button button
end

Given('I am on the sign-up page') do
  visit signup_path
end

Then('I should see {string}') do |expected_text|
  expect(page).to have_content(expected_text)
end

Then('I should be on the login page') do
  expect(current_path).to eq(login_path)
end
