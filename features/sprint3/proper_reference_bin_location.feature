Feature: Update Bin Location
  As a user
  I want each bin to reference a location
  So that items are properly categorized

  Scenario: Assign a location to a bin
    Given I am a logged-in user
    And a location "Warehouse A" exists
    When I visit the new bin page
    And I fill in the bin "Location" with "Warehouse A"    
    Then the bin should be associated with "Warehouse A"
