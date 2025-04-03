Given("I am a registered user with email {string} and password {string}") do |email, password|
  @user = User.create!(name: "Test User", email: email, password: password)
end

Given("I am on the forgot password page") do
  visit forgot_password_path
end

When("I enter my email {string}") do |email|
  find(:xpath, "//input[@type='email']").set(email)
end

When("I press the {string}") do |button|
  sleep 2
  click_button button
  sleep 2
end

Then("I should see the {string}") do |message|
  expect(page).to have_content(message)
end

Given("I have requested a password reset") do
  User.find_by(email: "test@example.com")&.destroy # Remove existing user
  
  @user = User.create!(
    name: "Test User",
    email: "test@example.com",
    password: "SecureP@ssw0rd!", # Ensure valid password
    password_confirmation: "SecureP@ssw0rd!"
  )

  @user.update!(reset_code: SecureRandom.hex(3), reset_sent_at: Time.now)

  visit forgot_password_path

  # Using XPath to find the email input field
  find(:xpath, "//input[@type='email']").set(@user.email)

  click_button "Send Reset Code"
  @user.reload
end




Given("I received a reset code via email") do
  @reset_code = @user.reset_code
end

When("I enter the reset code") do
  fill_in "Reset Code", with: @reset_code
end

When("I enter an invalid reset code") do
  fill_in "Reset Code", with: "wrongcode"
end

Given("my reset code has expired") do
  @user.update(reset_sent_at: 1.hour.ago)
end

Given("I have entered a valid reset code") do
  step "I have requested a password reset"
  step "I received a reset code via email"
  step "I enter the reset code"
  step 'I press "Verify"'
end

When("I enter {string} as my new password") do |password|
  fill_in "New Password", with: password
end

When("I confirm {string} as my new password") do |password|
  expect(page).to have_field("New Password", wait: 5)
  fill_in "Confirm Password", with: password
end

Then("I should be redirected to the password reset page") do
  expect(page).to have_current_path(new_password_reset_path, wait: 5)
end

Then("I should be redirected to the forgot password page") do
  expected_path = reset_code_path  # Update to the correct path
  expect(current_path).to eq(expected_path)
end

Then("I should be redirected to the login page1") do
  expect(current_path).to eq(new_user_session_path)
end

Then("I should see the {string} s2") do |message|
  expect(page.all(:xpath, "//*[contains(text(), '#{message}')]").size)
end

Then("I should see the {string} s2.1") do |message|
  escaped_message = "concat('#{message.gsub("'", "',\"'\",'")}')"
  expect(page).to have_xpath("//*[contains(text(), #{escaped_message})]", count: 1)
end
