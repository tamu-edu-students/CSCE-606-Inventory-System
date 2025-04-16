Given("I am a logged in user s4") do
  @user = User.create!(name: "Test User", email: "test@example.com", password: "Password1!")
  @location = FactoryBot.create(:location, user: @user)

  visit new_user_session_path
  fill_in "user[email]", with: @user.email
  fill_in "user[password]", with: "Password1!"
  click_button "Sign In"
end



Given("I have an unassigned item named {string}") do |name|
  Item.create!(name: name, user: @user, no_bin: true, location: @location, value: 10.0)
end

Given("I have an item named {string} assigned to bin {string}") do |item_name, bin_name|
  bin = Bin.find_by(name: bin_name)
  Item.create!(name: item_name, user: @user, bin: bin, location: bin.location, no_bin: false, value:10.0)
end

When("I click the delete button for {string}") do |item_name|
  sleep 1
  item = Item.find_by(name: item_name)
  find("form[action='/items/#{item.id}']").find("button").click
end

Then("I should see the message s4 {string}") do |message|
  expect(page).to have_content(message)
end

Then("I should see the alert {string}") do |message|
  expect(page).to have_content(message)
end

When("I visit the bin page for {string}") do |bin_name|
  bin = Bin.find_by!(name: bin_name)
  visit bin_path(bin)
end