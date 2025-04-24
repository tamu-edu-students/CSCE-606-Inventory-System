Given("a location named {string} exists for {string}") do |location_name, email|
  user = User.find_by(email: email)
  @location = FactoryBot.create(:location, name: location_name, user: user)
end

Given("a bin named {string} exists for {string} in {string}") do |bin_name, email, location_name|
  user = User.find_by(email: email)
  raise "User not found for email #{email}" unless user

  location = Location.find_by(name: location_name, user: user)
  raise "Location not found for #{location_name}" unless location

  @bin = FactoryBot.create(:bin, name: bin_name, user: user, location: location)
end

When("I go to the new item page") do
  visit new_item_path
end

#When("I leave the {string} field empty") do |field_label|
#  fill_in field_label, with: ""
#end

#When("I fill in {string} with {string}") do |field_label, value|
#  fill_in field_label, with: value
#end

#When("I select {string} from the bin dropdown") do |bin_name|
#  select bin_name, from: "item_bin_id"
#end

#When("I press {string}") do |button_text|
#  click_button button_text
#end

Then("I should see the item form again") do
  expect(page).to have_text("prohibited this item from being saved")
end

Then("I should see the items form again") do
  expect(page).to have_text("Please correct the following errors:")
end

Then("I should see the item error message {string}") do |text|
  expect(page).to have_text(text)
end



#Then("I should see {string}") do |text|
#  expect(page).to have_content(text)
#end

Given("an item named {string} exists in {string}") do |item_name, bin_name|
  bin = Bin.find_by(name: bin_name)
  @item = FactoryBot.create(:item, name: item_name, bin: bin, user: bin.user, location: bin.location)
end

When("I go to the edit page for {string}") do |item_name|
  item = Item.find_by(name: item_name)
  visit edit_item_path(item)
end

When("I clear the {string} field") do |field_label|
  fill_in field_label, with: ""
end
