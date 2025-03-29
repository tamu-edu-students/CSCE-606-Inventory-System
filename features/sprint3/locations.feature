Feature: Manage Locations

  Scenario: View locations
    Given I am logged in as a user
    And I am on the locations page
    Then I should see the text "Your Locations"
    And I should see a button "Add New Location"
    And I should see a link "Back to Dashboard"
    And I should see a table with headers "Name, Total Bins, Total Items, View Bins, View Items, Actions"

  Scenario: Add a new location
    Given I am logged in as a user
    And I am on the locations page
    When I click the "Add New Location" button
    Then I should see a modal with a form to add a new location
    When I fill in the location name and submit the form
    Then the new location should be added to the list

  Scenario: Search locations by name
    Given I am on the locations page
    And a location "Existing Location" exists
    And a location "Another Location" exists
    When I click the search icon in the "Name" header
    Then I should see an input field to search by name
    When I enter a name in the search field
    Then the locations table should be filtered to show only matching locations
