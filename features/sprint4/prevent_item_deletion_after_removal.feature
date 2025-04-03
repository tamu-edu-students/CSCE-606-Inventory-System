
Feature: Prevent Item Deletion After Bin Removal
  As a user
  I want items to remain in the system after removing them from bins
  So that I don't lose item data when reorganizing my inventory

  Background:
    Given I am a logged-in user
    And I have a bin named "Kitchen Stuff"
    And I have an item "Coffee Maker" in bin "Kitchen Stuff"

  Scenario: Removing an item from a bin
    When I visit the edit page for item "Coffee Maker"
    And I remove the bin assignment
    Then I should see "Item was successfully updated"
    And the item "Coffee Maker" should be unassigned


  Scenario: Reassigning an unassigned item
    Given I have an unassigned item "Blender"
    And I have a bin named "New Kitchen Bin"
    When I assign item "Blender" to bin "New Kitchen Bin"
    Then I should see "Item was successfully updated"
    And the item "Blender" should be in bin "New Kitchen Bin"

