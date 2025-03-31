Given("I am a logged-in user on the bins page") do
  visit bins_path
end

Given("I have bins with the following details:") do |table|
  table.hashes.each do |bin_data|
    Bin.create!(name: bin_data["Name"], category_name: bin_data["Category"], user: @current_user)
  end
end

When("I click on the {string} column header to sort ascending") do |column|
  find("th.sortable", text: column).click
end

When("I click on the {string} column header to sort descending") do |column|
  find("th.sortable", text: column).click
  find("th.sortable", text: column).click
end

Then("the bins should be displayed in the following order:") do |table|
  expected_order = table.raw.flatten
  actual_order = all("td[data-column='name']").map(&:text)
  expect(actual_order).to eq(expected_order)
end

When("I select {string} from the category filter") do |category|
  select category, from: "categoryFilter"
  sleep 1
end

Then("I should only see bins belonging to {string}") do |category|
  visible_bins = all("td[data-column='category']").map(&:text)
  expect(visible_bins.all? { |bin| bin == category }).to be true, "Expected only bins in '#{category}', but got: #{visible_bins}"
end

Then("I should see a message {string}") do |message|
  expect(page).to have_content(message)
end

When("I click the reset button") do
  click_button "Reset"
  sleep 1
end

Then("all bins should be visible again") do
  expect(page).to have_css(".bin-card", count: Bin.count)
end
