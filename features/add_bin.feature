Feature: Adding Bins
  As an authenticated user
  I want to create bins
  So that I can organize items efficiently

  Background:
    Given I am logged in as "user@example.com" with password "password123"

  Scenario: Successfully adding a bin
    When I visit the new bin page
    And I fill in "Name" with "Bin 1"
    And I press "Create Bin"
    Then I should see "Bin was successfully created"
