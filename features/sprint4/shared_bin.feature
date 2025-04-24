Feature: Manage Shared Bins
  As a user
  I want to share my bin with friends
  So they can access its contents

  Background:
    Given a user named "Alice" with email "alice@example.com"
    And a user named "Bob" with email "bob@example.com"
    And "alice@example.com" has a bin named "Alpha Bin"
    And "alice@example.com" is friends with "bob@example.com"
    And I am logged in as "alice@example.com"

  @javascript
  Scenario: Successfully share bin with a friend
    When I go to the share page for "Alpha Bin"
    And I select "bob@example.com" as a friend to share with
    And I press "Update Sharing"
    Then I should see "Bin shared successfully"

@javascript
  Scenario: Unshare bin from a friend
    Given "Alpha Bin" is already shared with "bob@example.com"x
    When I go to the share page for "Alpha Bin"
    And I deselect "bob@example.com" as a friend to share with
    And I press "Update Sharing"
    Then I should see "Bin sharing updated successfully."
    And "Alpha Bin" should not be shared with "bob@example.com"

  @javascript
  Scenario: View sale status of items
    Given Alpha Bin contains the following items:
    | name       | value | for_sale |
    | Wrench     | 15    | true     |
    | Hammer     | 10    | false    |
    When I visit the bin page for "Alpha Bin"xx
    Then I should see "Wrench" under items for sale
    And I should see "Hammer" under items not for sale