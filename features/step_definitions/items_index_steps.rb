Given("I am a logged in user") do
    @user = FactoryBot.create(:user)
    login_as(@user, scope: :user) # using Warden or Devise helpers
  end
  
  Given("there are some items created for me") do
    location = FactoryBot.create(:location, user: @user)
    bin = FactoryBot.create(:bin, user: @user, location: location)
    FactoryBot.create(:item, name: "Hammer", value: 20, user: @user, bin: bin, location: location)
    FactoryBot.create(:item, name: "Screwdriver", value: 45, user: @user, bin: bin, location: location)
    FactoryBot.create(:item, name: "Drill", value: 100, user: @user, bin: bin, location: location)
  end
  
  Given("I have no items") do
    # intentionally leave @items empty
  end
  
  When("I visit the items-page") do
    visit items_path
  end
  
  Then("I should see the caption {string}") do |text|
    expect(page).to have_text(text)
  end
  
  Then("I should see a {string} button") do |text|
    expect(page).to have_link(text, exact: false)
  end
  
  Then("I should see a {string} button labeled {string}") do |_, text|
    expect(page).to have_link(text)
  end
  
  Then("I should see a text input with id {string}") do |id|
    expect(page).to have_selector("input[type='text']##{id}")
  end
  
  Then("I should see a number input with id {string}") do |id|
    expect(page).to have_selector("input[type='number']##{id}")
  end
  
  Then("I should see a button with id {string}") do |id|
    expect(page).to have_selector("button##{id}")
  end
  
  Then("I should see item cards for all my items") do
    expect(page).to have_selector(".item-card", count: Item.where(user: @user).count)
  end
  
  When("I filter items by name {string}") do |query|
    fill_in "filterInput", with: query
    # simulate JS behavior if needed
    page.execute_script("document.getElementById('filterInput').dispatchEvent(new Event('input'))")
  end
  
  When("I filter items by value {string}") do |value|
    fill_in "valueFilter", with: value
    page.execute_script("document.getElementById('valueFilter').dispatchEvent(new Event('input'))")
  end
  
  Then("I should only see item cards containing {string}") do |text|
    all(".item-card").each do |card|
      expect(card[:'data-name']).to include(text.downcase)
    end
  end
  
  Then("I should only see item cards with value less than or equal to {int}") do |value|
    all(".item-card").each do |card|
      expect(card[:'data-value'].to_f).to be <= value
    end
  end
  
  Then("I should see the message {string}") do |text|
    expect(page).to have_text(text)
  end

  Then("I should see a button labeled {string}") do |label|
    expect(page).to have_selector("a,button", text: label)
  end
  