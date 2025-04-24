Feature: Delete an empty bin
  As a logged-in user
  I want to delete a bin that has no items
  So that I can keep my bins organized

  Background:
    Given a user named "Alice" with email "alice@example.com"
    And I am logged in as "alice@example.com"
    And "alice@example.com" has an empty bin named "Old Bin"

  @javascript
  Scenario: Successfully delete a bin with no items
    When I visit the bins page
    And I click delete on the bin named "Old Bin"
    Then I should see "Bin was successfully deleted."
    And I should not see the bin named "Old Bin"
