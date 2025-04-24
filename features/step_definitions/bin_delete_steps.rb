
When("I visit the bins page") do
  visit bins_path
end

When('I click delete on the bin named {string}') do |bin_name|
  using_wait_time 5 do
    # Print page content to debug (optional)
    puts page.body if ENV['DEBUG'] == 'true'

    # Try to find a matching bin card by title
    card = all('.bin-card').find do |div|
      div.has_selector?('h5', text: bin_name)
    end

    raise "❌ Could not find a bin card with name #{bin_name}" unless card

    # Open the 3-dot dropdown menu
    within(card) do
      find('button.btn-light.btn-sm.rounded-circle.shadow-sm').click
    end

    # Click the 'Delete' option
    within(card) do
      find('button.dropdown-item.text-danger', text: /Delete/i).click
    end
  end
end


Then("I should not see the bin named {string}") do |bin_name|
  expect(page).not_to have_selector(".bin-card h5", text: bin_name)
end

Given('{string} has an empty bin named {string}') do |email, bin_name|
  user = User.find_by(email: email) || FactoryBot.create(:user, email: email, password: "Password1!", name: email.split('@').first)
  location = FactoryBot.create(:location, user: user, name: "Default Location")
  FactoryBot.create(:bin, name: bin_name, user: user, location: location)
end
