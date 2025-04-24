Given("a user named {string} with email {string} and password {string}") do |name, email, password|
  @user = FactoryBot.create(:user, name: name, email: email, password: password, password_confirmation: password)
end

Given("I am logged in session as {string}") do |email|
  user = User.find_by(email: email)
  login_as(user, scope: :user) # Warden/Devise helper
end

#When("I visit the login page") do
#  visit new_user_session_path
#end

Then("I should be redirected to the dashboard session") do
  expect(current_path).to eq(dashboard_path)
end


When("I visit the dashboard pagex") do
  visit dashboard_path
  expect(page).to have_content("You need to sign in or sign up before continuing.")
end
