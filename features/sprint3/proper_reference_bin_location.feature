Feature: Update Bin Location
  As a user
  I want each bin to reference a location
  So that items are properly categorized

  @javascript
  Scenario: Assign a location to a bin
    Given I am a logged-in user
    And a location "Warehouse B" exists
    When I visit the new bin page
    And I fill in the bin "Location" with "Warehouse B"    
    Then the bin should be associated with "Warehouse B"
