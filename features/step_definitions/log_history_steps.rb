Given("I have a location named {string}") do |name|
  @location = FactoryBot.create(:location, name: name, user: @user)
end

Given("I have a bin named {string} in {string}") do |bin_name, location_name|
  location = Location.find_by(name: location_name, user: @user)
  @bin = FactoryBot.create(:bin, name: bin_name, location: location, user: @user)
end

Given("I have an item named {string} in bin {string}") do |item_name, bin_name|
  bin = Bin.find_by(name: bin_name, user: @user)
  @item = FactoryBot.create(:item, 
    name: item_name, 
    bin: bin, 
    location: bin.location, 
    user: @user,
    value: 10.0
  )
end

When("I create an item named {string} in bin {string}") do |item_name, bin_name|
  visit new_item_path
  fill_in "Name", with: item_name
  fill_in "Description", with: "A test description"
  fill_in "Value", with: "10.0"
  select bin_name, from: "item[bin_id]"
  click_button "Create Item"
end

When("I update the item {string} name to {string}") do |old_name, new_name|
  item = Item.find_by(name: old_name, user: @user)
  visit edit_item_path(item)
  fill_in "Name", with: new_name
  click_button "Update Item"
end

When("I visit the log history page") do
  visit logs_path
end

Then("I should see a log entry for {string} with action {string}") do |item_name, action|
  within(".log-entries") do
    expect(page).to have_content(item_name)
    expect(page).to have_content(action)
  end
end

Then("I should see {string} before {string} in the log history") do |first_item, second_item|
  within(".log-entries") do
    log_entries = all(".log-entry").map(&:text)
    first_index = log_entries.find_index { |entry| entry.include?(first_item) }
    second_index = log_entries.find_index { |entry| entry.include?(second_item) }
    
    expect(first_index).not_to be_nil, "Could not find '#{first_item}' in the log entries"
    expect(second_index).not_to be_nil, "Could not find '#{second_item}' in the log entries"
    expect(first_index).to be < second_index
  end
end
