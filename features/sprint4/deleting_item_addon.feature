Feature: Deleting an item

  Background:
    Given I am a logged in user s4

  @javascript
  Scenario: User deletes an unassigned item
    Given I have an unassigned item named "Loose Screw"
    When I visit the items-page
    And I click the delete button for "Loose Screw"
    Then I should see the message s4 "Item deleted"

  @javascript
  Scenario: User tries to delete an item that is assigned to a bin
    Given I have a bin named "Toolbox"
    And I have an item named "Wrench" assigned to bin "Toolbox"
    When I visit the items-page
    And I click the delete button for "Wrench"
    Then I should see the alert "Item was unassigned, click delete again to permanently delete it"
