Feature: Adding Items to Bin
  As an authenticated user
  I want to add items to bins
  So that I can manage inventory

  Background:
    Given I am logged in as "user@example.com" with password "password123"
    And a bin named "Bin 1" exists

  Scenario: Successfully adding an item to a bin
    When I visit the new item page
    And I select "Bin 1" from "Bin"
    And I fill in "Item name" with "Item A"
    And I fill in "Quantity" with "5"
    And I press "Add Item"
    Then I should see "Item was successfully added to Bin 1"
