Feature: Handle Item Creation and Update Errors

  Background:
    Given a user named "Alice" with email "alice@example.com"
    And a location named "Tool Shed" exists for "alice@example.com"
    And a bin named "Hardware Bin" exists for "alice@example.com" in "Tool Shed"
    And I am logged in as "alice@example.com"

  @javascript
  Scenario: Fail to create an item with missing name
    When I go to the new item page
    And I leave the "Name" field empty
    And I fill in "Value" with "50"
    And I select "Hardware Bin" from the bin dropdown
    And I press "Create Item"
    Then I should see the item form again
    And I should see "prohibited this item from being saved"

  @javascript
  Scenario: Fail to update item due to missing name
    Given an item named "Broken Screw" exists in "Hardware Bin"
    When I go to the edit page for "Broken Screw"
    And I clear the "Name" field
    And I press "Update Item"
    Then I should see the items form again
    And I should see "prohibited this item from being saved"
