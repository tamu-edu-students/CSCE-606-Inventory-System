Feature: Item suggestion

  Background:
    Given I am a logged in user
    And there are some items created for me

  @javascript
  Scenario: Suggestions API returns matching items
    Given I am a logged in user
    And there are some items created for me
    When I visit the dashboard page
    When I request item suggestions with query "ammer"
    Then I should see a item suggestion with name "Hammer"
