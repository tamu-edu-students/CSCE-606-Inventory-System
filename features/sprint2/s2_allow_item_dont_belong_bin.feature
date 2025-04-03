
Feature: Create Items Without Bin Assignment
  As a user
  I want to create items without assigning them to bins
  So that I can catalog items before organizing them

  Background:
    Given I am a logged-in user
    And I have a valid location

  @javascript
  Scenario: Creating an item without a bin
    When I visit the new item page
    And I fill in the item field "name" with "New Camera"
    And I fill in the item field "value" with "499.99"
    And I click "Create Item"
    Then I should see "Item was successfully created"

  @javascript
  Scenario: Validation errors when creating unassigned item
    When I visit the new item page
    And I fill in the item field "value" with "-10.00"
    And I click "Create Item"
    Then I should see "t be blank"

  @javascript
  Scenario: Creating an item and assigning it to a bin later
    Given I have an unassigned item "Old Laptop"
    And I have a bin named "Electronics"
    When I visit the edit page for item "Old Laptop"
    And I click "Update Item"
    Then I should see "Item was successfully updated"

  @javascript
  Scenario: Viewing unassigned items
    Given I have an unassigned item "Old Phone"
    When I visit the items page
    Then I should see "Old Phone"

