Feature: Bin suggestions
  As a logged-in user
  I want to see bin suggestions when I type in the search box
  So that I can quickly find bins or categories

  Background:
    Given I am a logged-in user
    And I have bins with the following details:
      | Name          | Category      |
      | Office Bin    | Stationery    |
      | Hardware Bin  | Tools         |
      | Storage Bin   | Miscellaneous |
      | Bookshelf Bin | Books         |

  @javascript
  Scenario: Typing in bin search triggers suggestions
    When I visit the dashboard page
    And I fill in the bin search box with "Off"
    Then I should see a bin suggestion with name "Office Bin"

  @javascript
  Scenario: Filtering bins by category using the category dropdown
    When I select "Tools" from the category filter
    Then I should only see bins belonging to "Tools"