Feature: Manage Friendships
  As a logged-in user
  I want to add and remove friends
  So that I can share bins with them

  Background:
    Given a user named "Alice" with email "alice@example.com"
    And a user named "Bob" with email "bob@example.com"

  @javascript
  Scenario: Add a friend successfully
    Given I am logged in as "alice@example.com"
    When I go to the friendships page
    And I fill in "email" with "bob@example.com" s4
    And I press "Add Friend" s4
    Then I should see "Successfully added bob@example.com as a friend" s4

  @javascript
  Scenario: Attempt to add self as friend
    Given I am logged in as "alice@example.com"
    When I go to the friendships page
    And I fill in "email" with "alice@example.com" s4
    And I press "Add Friend" s4
    Then I should see "Friend can't be the same as user" s4

  @javascript
  Scenario: Remove a friend
    Given I am logged in as "alice@example.com"
    Given "alice@example.com" is already friends with "bob@example.com"
    When I go to the friendships page
    And I click "Remove" next to "bob@example.com"
    Then I should see "Removed bob@example.com from friends"

  @javascript
  Scenario: View list of friends
    Given I am logged in as "alice@example.com"
    Given "alice@example.com" is already friends with "bob@example.com"
    When I go to the friendships page
    Then I should see "bob@example.com"
