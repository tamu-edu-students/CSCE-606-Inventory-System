Feature: Viewing and filtering items

  Background:
    Given I am a logged in user
    And there are some items created for me

  Scenario: User sees the items index page with header and buttons
    When I visit the items-page
    Then I should see the caption "My Items"
    And I should see a "New Item" button
    And I should see a "Back to Dashboard" button

  Scenario: User sees the filter inputs
    When I visit the items-page
    Then I should see a text input with id "filterInput"
    And I should see a number input with id "valueFilter"
    And I should see a button with id "resetFilters"

  @javascript
  Scenario: User sees a list of item cards
    When I visit the items-page
    Then I should see item cards for all my items

  @javascript
  Scenario: User filters items by name
    When I visit the items-page
    When I filter items by name "screwdriver"
    Then I should only see item cards containing "screwdriver"

  @javascript
  Scenario: User filters items by value
    When I visit the items-page
    When I filter items by value "50"
    Then I should only see item cards with value less than or equal to 50

  @javascript
  Scenario: User sees no matching results
    When I visit the items-page
    When I filter items by name "doesnotexist"
    Then I should see the message "No items to display"

  Scenario: User sees no items message when no items exist
    Given I have no items
    When I visit the items-page
    Then I should see the message "No items yet"
    And I should see a button labeled "Add Item"
