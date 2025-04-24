When("I go to the new bin page") do
  visit new_bin_path
end

When("I fill in the new location field with {string}") do |value|
  fill_in "bin_new_location", with: value
  sleep 1
end

When("I fill in the bin name with {string}x") do |name|
  fill_in "bin_name", with: name
end


#Then("I should see {string}") do |text|
#  expect(page).to have_text(text)
#end
