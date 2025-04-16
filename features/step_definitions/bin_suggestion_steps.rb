When("I fill in the bin search box with {string}") do |query|
  fill_in "search-inventory", with: query
  sleep 1.5 # Allow debounce + fetch to complete
end

Then("I should see a bin suggestion with name {string}") do |name|
  within("#bin-suggestions") do
    expect(page).to have_content(name)
  end
end

When("I visit the dashboard page") do
  visit dashboard_path
  expect(page).to have_content("Welcome to Your Inventory")
end


