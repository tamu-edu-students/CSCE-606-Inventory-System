Given('I am a logged in user with email {string}') do |email|
  @user = User.create!(
    email: email,
    password: 'Password1!',
    name: 'Test User'
  )
  
  visit new_user_session_path
  fill_in 'user[email]', with: email
  fill_in 'user[password]', with: 'Password1!'
  click_button 'Login'
end

Given('I have logged in {int} times before') do |count|
  count.times do |i|
    Session.create!(
      user: @user,
      login_time: (count - i).hours.ago,
      logout_time: (count - i - 1).hours.ago
    )
  end
end

When('I click on the profile icon') do
  find('#profile-trigger').click
end

Then('I should see my email {string} in the dropdown') do |email|
  within('#profile-dropdown-content') do
    expect(page).to have_content(email)
  end
end

Then('I should see my last login time') do
  within('#profile-dropdown-content') do
    expect(page).to have_content(Session.where(user: @user).last.login_time.strftime("%Y-%m-%d %H:%M"))
  end
end

Then('I should see a logout button') do
  within('#profile-dropdown-content') do
    expect(page).to have_button('Logout')
  end
end

When('I click outside the dropdown') do
  page.find('body').click
end

Then('the dropdown should be closed') do
  expect(page).not_to have_css('#profile-dropdown-content.active')
end

When('I click the logout button') do
  within('#profile-dropdown-content') do
    click_button 'Logout'
  end
end

When('I confirm the logout') do
  accept_confirm
end