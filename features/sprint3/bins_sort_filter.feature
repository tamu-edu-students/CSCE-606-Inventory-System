Feature: Sorting and Filtering Bins
  As a user,
  I want to sort bins alphabetically,
  And filter them by category,
  So that I can easily manage my storage.

  Background:
    Given I am a logged-in user on the bins page
    And I have bins with the following details:
      | Name          | Category      |
      | Office Bin    | Stationery    |
      | Hardware Bin  | Tools         |
      | Storage Bin   | Miscellaneous |
      | Bookshelf Bin | Books         |

  ### ✅ Sorting Tests ###
  @javascript
  Scenario: Sorting bins alphabetically (A-Z)
    When I click on the "Name" column header to sort ascending
    Then the bins should be displayed in the following order:
      | Name          |
      | Bookshelf Bin |
      | Hardware Bin  |
      | Office Bin    |
      | Storage Bin   |

  @javascript
  Scenario: Sorting bins alphabetically (Z-A)
    When I click on the "Name" column header to sort descending
    Then the bins should be displayed in the following order:
      | Name          |
      | Storage Bin   |
      | Office Bin    |
      | Hardware Bin  |
      | Bookshelf Bin |

  ### ✅ Filtering Tests ###
  @javascript
  Scenario: Filtering bins by category
    When I select "Stationery" from the category filter
    Then I should only see bins belonging to "Stationery"

  @javascript
  Scenario: Filtering bins with no matching category
    When I select "Electronics" from the category filter
    Then I should see a message "No bins found"

  @javascript
  Scenario: Resetting filters
    Given I selected a category filter
    When I click the reset button
    Then all bins should be visible again
