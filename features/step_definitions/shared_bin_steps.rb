Given(/^"([^"]+)" has a bin named "([^"]+)"$/) do |email, bin_name|
  user = User.find_by(email: email)
  location = Location.create!(name: "Test Location", user: user)
  Bin.create!(name: bin_name, user: user, location: location, category_name: "Tools", is_shared: true)
end

When("I go to the share page for {string}") do |bin_name|
  bin = Bin.find_by(name: bin_name)
  visit share_bin_path(bin)
end

When("I select {string} as a friend to share with") do |friend_email|
  friend = User.find_by(email: friend_email)
  checkbox_id = "friend_#{friend.id}"
  expect(page).to have_css("##{checkbox_id}", visible: false) # Just in case it's styled differently
  check(checkbox_id, allow_label_click: true)
end


Given(/^"([^"]+)" is already shared with "([^"]+)"$/) do |bin_name, friend_email|
  bin = Bin.find_by(name: bin_name)
  friend = User.find_by(email: friend_email)
  bin.share_with(friend)
end


Given(/^"([^"]+)" is friends with "([^"]+)"$/) do |user_email, friend_email|
  user = User.find_by(email: user_email)
  friend = User.find_by(email: friend_email)
  user.friendships.create!(friend: friend)
end


Given("Alpha Bin contains the following items:") do |table|
  bin = Bin.find_by!(name: "Alpha Bin")
  table.hashes.each do |item_data|
    bin.items.create!(
      name: item_data["name"],
      value: item_data["value"],
      for_sale: item_data["for_sale"] == "true",
      user: bin.user,
      location: bin.location
    )
  end
end

Given("{string} is already shared with {string}x") do |bin_name, friend_email|
  bin = Bin.find_by!(name: bin_name)
  friend = User.find_by!(email: friend_email)
  bin.update!(is_shared: true)
  bin.share_with(friend)
end

When("I deselect {string} as a friend to share with") do |email|
  user = User.find_by!(email: email)
  uncheck("friend_#{user.id}")
end


Then("{string} should not be shared with {string}") do |bin_name, friend_email|
  bin = Bin.find_by!(name: bin_name)
  friend = User.find_by!(email: friend_email)
  expect(bin.shared_with_users).not_to include(friend)
end

When("I visit the bin page for {string}xx") do |bin_name|
  bin = Bin.find_by!(name: bin_name)
  visit bin_path(bin)
end

Then("I should see {string} under items for sale") do |item_name|
  rows = all("table tr")
  found = rows.any? do |row|
    row.has_text?(item_name) && row.has_css?("span.badge.bg-success", text: "Yes")
  end
  expect(found).to be(true), "Expected to find '#{item_name}' with 'Yes' badge, but did not."
end

Then("I should see {string} under items not for sale") do |item_name|
  rows = all("table tr")
  found = rows.any? do |row|
    row.has_text?(item_name) && row.has_css?("span.badge.bg-secondary", text: "No")
  end
  expect(found).to be(true), "Expected to find '#{item_name}' with 'No' badge, but did not."
end

