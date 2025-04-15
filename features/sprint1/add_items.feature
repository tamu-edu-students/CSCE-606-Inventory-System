Feature: Adding Items to Bin
  As an authenticated user
  I want to add items to bins
  So that I can manage inventory

  Background:
    Given I am a logged-in user
    And I have a bin named "Storage Bin"

  @javascript
  Scenario: Successfully adding an item to a bin
    When I visit the new item page
    And I fill in the item field "name" with "Item A"
    And I fill in the item field "value" with "100"
    And I select "Storage Bin" from the bin dropdown
    And I press "Create Item"
    Then I should see "Item was successfully created"
    And I should be redirected to the item details page


