Feature: View Log History
  As a logged-in user
  I want to see a history of actions performed on my inventory
  So that I can track changes to my items and bins

  Background:
    Given I am a logged in user
    And I have a location named "Garage"
    And I have a bin named "Tools" in "Garage"

  @javascript
  Scenario: View log history after creating an item
    When I create an item named "Hammer" in bin "Tools"
    And I visit the log history page
    Then I should see "Inventory Log History"
    And I should see a log entry for "Hammer" with action "create"

  @javascript
  Scenario: View log history after updating an item
    Given I have an item named "Screwdriver" in bin "Tools"
    When I update the item "Screwdriver" name to "Power Screwdriver"
    And I visit the log history page
    Then I should see a log entry for "Power Screwdriver" with action "update"

  @javascript
  Scenario: Log entries are ordered by most recent first
    Given I have an item named "Wrench" in bin "Tools"
    And I have an item named "Pliers" in bin "Tools"
    When I visit the log history page
    Then I should see "Pliers" before "Wrench" in the log history