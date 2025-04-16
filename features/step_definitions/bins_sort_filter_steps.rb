Given("I am a logged-in user on the bins page") do
  @user = User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!')
  @location = FactoryBot.create(:location, user: @user)
  visit new_user_session_path
  fill_in "user[email]", with: "test@example.com"
  fill_in "user[password]", with: "Password1!"
  click_button "Sign In"
  sleep 1
end

Given("I have bins with the following details:") do |table|
  table.hashes.each do |bin_data|
    Bin.create!(name: bin_data["Name"], category_name: bin_data["Category"], user: @user, location:@location)
  end
  sleep 1
  visit bins_path
  sleep 1
end

When("I click on the {string} column header to sort ascending") do |column|
  click_button "Sort by Name"
end

When("I click on the {string} column header to sort descending") do |column|
  if column.downcase == "name"
    find("#sortByName").click
    find("#sortByName").click
  else
    raise "Sorting by '#{column}' is not implemented yet"
  end
end


Then("the bins should be displayed in the following order:") do |table|
  expected_names = table.raw.flatten[1..] # skip "Name" header
  actual_names = all(".card-title").map { |card| card.text.strip }
  expect(actual_names).to eq(expected_names)
end


When("I select {string} from the category filter") do |category|
  select category, from: "categoryFilter"
  sleep 1
end

Then("I should only see bins belonging to {string}") do |category|
  visible_cards = all(".bin-card", visible: true)
  mismatched = visible_cards.reject do |card|
    card_category = card[:'data-category']&.strip
    card_category == category
  end

  expect(mismatched).to be_empty, "Found bins not in category '#{category}': #{mismatched.map { |c| c[:'data-category'] }}"
end


Then("I should see a message {string}") do |message|
  expect(page).to have_content(message)
end

When("I select all categories") do
  select 'All Categories', from: "categoryFilter"
  sleep 1
end

Then("all bins should be visible again") do
  expect(page).to have_css(".bin-card", count: Bin.count)
end
