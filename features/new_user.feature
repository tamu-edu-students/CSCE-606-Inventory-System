Feature: User Registration and Login
  As a new user
  I want to register an account and log in
  So that I can access the system

  Scenario: Successful registration and login
    Given I am on the sign-up page
    When I fill in "Name" with "New User"
    And I fill in "Email" with "new_user@example.com"
    And I fill in "Password" with "Newpassword123!"
    And I fill in "Password confirmation" with "Newpassword123!"
    And I press "Sign Up"
    Then I should be on the login page
    When I fill in "email" with "new_user@example.com"
    And I fill in "password" with "Newpassword123!"
    And I press "Login"
    Then I should see "Welcome, New User!"
