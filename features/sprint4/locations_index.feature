Feature: Managing Locations

  Background:
    Given I am a logged in as a user
    And there are some locations created for me

  Scenario: User sees the locations index page header and buttons
    When I visit the locations page
    Then I should see the heading "Your Locations"
    And I should see "New Location" button
    And I should see a "Back to Dashboard" button

  Scenario: User sees the search bar
    When I visit the locations page
    Then I should see a text input with id as "locationSearch"

  @javascript
  Scenario: User sees all location cards
    When I visit the locations page
    Then I should see location cards for all my locations

  @javascript
  Scenario: User filters locations by name
    When I visit the locations page
    And I filter locations by name "warehouse"
    Then I should only see location cards containing "warehouse"

  @javascript
  Scenario: User sees message when no locations match search
    When I visit the locations page
    And I filter locations by name "notfound"
    Then I should see the error "No locations to display"

  @javascript
  Scenario: User sees the add, edit, delete, and warning modals
    When I visit the locations page
    Then I should see the modal with id "addLocationModal"
    And I should see the modal with id "editLocationModal"
    And I should see the modal with id "deleteLocationModal"
    And I should see the modal with id "warningModal"

    @javascript
    Scenario: User adds a new location
    When I visit the locations page
    When I open the Add Location modal
    And I fill in the name "My New Location"
    And I submit the add location form
    Then I should see a location card with name "My New Location"

    @javascript
    Scenario: User edits a location
    When I visit the locations page
    When I open the Edit Location modal for the first location
    And I update the name to "Renamed Location"
    And I submit the edit location form
    Then I should see a location card with name "Renamed Location"

    @javascript
    Scenario: User deletes a location
    When I visit the locations page
    And the first location does not have bins and items
    And I open the Delete Location modal for the first location
    And I confirm the delete action
    Then I should not see the deleted location on the page

    @javascript
    Scenario: User tries to delete a location with bins/items
    When I visit the locations page
    And the first location has bins and items
    And I click delete on the first location
    Then I should see the warning modal
    And I should see "Please delete the bins and the associated items before you delete this location."

