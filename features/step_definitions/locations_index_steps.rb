
Given("I am a logged in as a user") do
    @user = FactoryBot.create(:user)
    login_as(@user, scope: :user) # using Warden or Devise helpers
  end
  
Given("I am logged in as a user") do
  @user = FactoryBot.create(:user)
  login_as(@user, scope: :user) # using Warden or Devise helpers
end

Given("there are some locations created for me") do
location = FactoryBot.create(:location, user: @user)
bin = FactoryBot.create(:bin, user: @user, location: location)
FactoryBot.create(:item, name: "Hammer", value: 20, user: @user, bin: bin, location: location)
FactoryBot.create(:item, name: "Screwdriver", value: 45, user: @user, bin: bin, location: location)
FactoryBot.create(:item, name: "Drill", value: 100, user: @user, bin: bin, location: location)
end

When("I visit the locations page") do
    visit locations_path
  end
  
  Then("I should see the heading {string}") do |text|
    expect(page).to have_selector("h1", text: text)
  end
  
  Then("I should see {string} button") do |text|
    expect(page).to have_selector("a,button", text: text)
  end
  
  Then("I should see a text input with id as {string}") do |id|
    expect(page).to have_selector("input[type='text']##{id}")
  end
  
  Then("I should see location cards for all my locations") do
    expect(page).to have_selector(".location-card", count: Location.where(user: @user).count)
  end
  
  When("I filter locations by name {string}") do |query|
    fill_in "locationSearch", with: query
    page.execute_script("document.getElementById('locationSearch').dispatchEvent(new Event('input'))")
  end
  
  Then("I should only see location cards containing {string}") do |text|
    all(".location-card").each do |card|
      expect(card["data-name"]).to include(text.downcase)
    end
  end
  
  Then("I should see the modal with id {string}") do |id|
    expect(page).to have_selector("##{id}", visible: :all)
  end
  
  Then("I should see the error {string}") do |text|
    expect(page).to have_text(text)
  end

  When("I open the Add Location modal") do
    find("button.addLocationBtn").click
    expect(page).to have_selector("#addLocationModal", visible: true)
  end
  
  When("I fill in the name {string}") do |name|
    within("#addLocationModal") do
      fill_in "location_name", with: name
    end
  end
  
  When("I submit the add location form") do
    within("#addLocationModal") do
      click_button "Add Location"
    end
  end
  
  Then("I should see a location card with name {string}") do |name|
    expect(page).to have_selector(".location-card h5", text: name)
  end
  
  When("I open the Edit Location modal for the first location") do
    first(".editLocationBtn").click
    expect(page).to have_selector("#editLocationModal", visible: true)
  end
  
  When("I update the name to {string}") do |new_name|
    within("#editLocationModal") do
      fill_in "location_name", with: new_name
    end
  end
  
  When("I submit the edit location form") do
    within("#editLocationModal") do
      click_button "Update Location"
    end
  end

  When("the first location does not have bins and items") do
    location = Location.where(user: @user).first
    location.bins.each { |bin| bin.items.destroy_all }
    location.bins.destroy_all
    location.items.destroy_all
    visit current_path
  end
  
  When("I open the Delete Location modal for the first location") do
    first(".deleteLocationBtn").click
    expect(page).to have_selector("#deleteLocationModal", visible: :all)
  end
  
  When("I confirm the delete action") do
    using_wait_time 5 do
      within("#deleteLocationModal", visible: true) do
        click_button "Yes"
      end
    end
    sleep 1 
  end
  
  
  Then("I should not see the deleted location on the page") do
    expect(page).not_to have_selector(".location-card", count: Location.count + 1)
  end
  
  When("the first location has bins and items") do
    location = Location.where(user: @user).first
    FactoryBot.create(:bin, user: @user, location: location)
    FactoryBot.create(:item, user: @user, bin: location.bins.first, location: location)
  end
  
  When("I click delete on the first location") do
    first(".deleteLocationBtn").click
  end
  
  Then("I should see the warning modal") do
    expect(page).to have_selector("#warningModal", visible: true)
  end
  
  Then("I should see the edit location form again") do
    expect(page).to have_selector("form.edit_location") # Adjust selector if needed
  end
  
  Then("I should see the error {string}xx") do |message|
    expect(page).to have_text(message)
  end

  Given('there is a location named {string} for me') do |name|
    @location = FactoryBot.create(:location, name: name, user: @user)
  end
  
  
  When("I visit the edit page for the location named {string}") do |name|
    location = Location.find_by!(name: name)
    visit edit_location_path(location)
    sleep 30
  end
  
  When("I update the location name to {string}") do |new_name|
    fill_in "location_name", with: new_name
  end
  
  Then("I should be redirected to the locations page") do
    expect(current_path).to eq(locations_path)
  end