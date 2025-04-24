Given("a user named {string} with email {string}") do |name, email|
  User.create!(name: name, email: email, password: "Password1!", password_confirmation: "Password1!")
end

Given("I am logged in as {string}") do |email|
  visit new_user_session_path
  fill_in "user[email]", with: email
  fill_in "user[password]", with: "Password1!"
  click_button "Sign In"
  sleep 1
end


When("I go to the friendships page") do
  visit friendships_path
  sleep 5
end

When("I fill in {string} with {string} s4") do |field, value|
  # Use a fallback strategy if Capybara can't find the field by label
  if has_field?(field, visible: true)
    fill_in field, with: value
  else
    # Directly target by `name` attribute
    find("input[name='#{field}']", visible: :all).set(value)
  end
end


When("I press {string} s4") do |button|
  click_button button
  sleep 1
end

Then("I should see {string} s4") do |text|
  expect(page).to have_content(text)
end

Given("{string} is already friends with {string}") do |email1, email2|
  user = User.find_by(email: email1)
  friend = User.find_by(email: email2)
  user.friendships.create!(friend: friend)
end

When("I click {string} next to {string}") do |button_text, email|
  friend_card = find(:xpath, "//div[contains(@class, 'list-group-item')]//h6[text()='#{email}']/ancestor::div[contains(@class, 'list-group-item')]")
  
  within(friend_card) do
    click_button(button_text)
  end
end

