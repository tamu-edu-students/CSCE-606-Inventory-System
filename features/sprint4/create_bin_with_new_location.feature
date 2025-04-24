Feature: Create a bin with a new location
  As a logged-in user
  I want to create a bin and specify a new location name
  So that I don't have to pre-create the location separately

  Background:
    Given a user named "Alice" with email "alice@example.com"
    And I am logged in as "alice@example.com"

  @javascript
  Scenario: Create a new bin with a brand new location
    When I go to the new bin page
    When I fill in the bin name with "Garden Tools"x
    And I fill in the new location field with "Backyard Shed"
    And I press "Create Bin"
    Then I should see "Bin was successfully created."
    And I should see "Garden Tools"
    And I should see "Backyard Shed"
