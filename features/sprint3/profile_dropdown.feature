Feature: Profile Dropdown
  As a logged in user
  I want to access my profile information via a dropdown
  So that I can view my details and logout

  Background:
    Given I am a logged in user with email "test@example.com"

  @javascript
  Scenario: Opening the profile dropdown
    When I click on the profile icon
    Then I should see my email "test@example.com" in the dropdown
    And I should see my last login time
    And I should see a logout button

  @javascript
  Scenario: Closing the profile dropdown by clicking outside
    When I click on the profile icon
    And I click outside the dropdown
    Then the dropdown should be closed

  @javascript
  Scenario: Logging out through the dropdown
    When I click on the profile icon
    And I click the logout button
    Then I should be redirected to the log-in page
    And I should see "Signed out successfully"