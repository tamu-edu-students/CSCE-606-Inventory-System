Then('I should see {string} in the unassigned items list') do |item_name|
  within('#unassigned-items') do
    expect(page).to have_content(item_name)
  end
  sleep 1
end

Then('the item {string} should have no bin assigned') do |item_name|
  item = Item.find_by(name: item_name)
  expect(item.bin).to be_nil
  expect(item.no_bin).to be true
  sleep 1
end

When('I leave the {string} field empty') do |field_name|
  fill_in field_name, with: ''
  sleep 1
end

Given('I have an unassigned item {string}') do |item_name|
  Item.create!(
    name: item_name,
    value: 100.00,
    no_bin: true,
    bin_id: nil,
    user: @user
  )
  sleep 1
end

When('I visit the edit page for item {string}') do |item_name|
  item = Item.find_by!(name: item_name)
  visit edit_item_path(item)
  sleep 1
end

Then('I should see {string} in the {string} items list') do |item_name, bin_name|
  within("#bin-#{bin_name.parameterize}") do
    expect(page).to have_content(item_name)
  end
  sleep 1
end

Given('I have the following unassigned items:') do |table|
  table.hashes.each do |item|
    Item.create!(
      name: item['name'],
      description: item['description'],
      value: item['value'],
      no_bin: true,
      bin_id: nil
    )
  end
  sleep 1
end

When('I visit the items page') do
  visit items_path
end

Then('I should see an {string} section') do |section_name|
  expect(page).to have_css("##{section_name.parameterize}")
end

Given('I have an item {string} in bin {string}') do |item_name, bin_name|
  bin = Bin.find_by!(name: bin_name)
  @item = Item.create!(
    user: @user,
    name: item_name,
    value: 100.00,
    bin: bin,
    no_bin: false
  )
end

When('I remove the bin assignment') do
  select 'No Bin', from: 'binSelect'
  click_button 'Update Item'
  sleep 1
end

Then('the item {string} should be unassigned') do |item_name|
  item = Item.find_by!(name: item_name)
  expect(item.bin).to be_nil
  expect(item.no_bin).to be true
end

When('I try to delete item {string}') do |item_name|
  item = Item.find_by!(name: item_name)
  # Since we can't handle JavaScript confirmations in the default driver,
  # we'll directly trigger the delete action
  page.driver.submit :delete, item_path(item), {}
  sleep 1
end

When('I assign item {string} to bin {string}') do |item_name, bin_name|
  item = Item.find_by!(name: item_name)
  visit edit_item_path(item)
  sleep 1
  select bin_name, from: 'binSelect'
  click_button 'Update Item'
  sleep 1
end

Then('the item {string} should be in bin {string}') do |item_name, bin_name|
  item = Item.find_by!(name: item_name)
  bin = Bin.find_by!(name: bin_name)
  expect(item.bin).to eq(bin)
  expect(item.no_bin).to be false
  sleep 1
end
