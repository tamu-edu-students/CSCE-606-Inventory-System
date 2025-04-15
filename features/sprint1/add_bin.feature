Feature: Adding Bins
  As an authenticated user
  I want to create bins
  So that I can organize items efficiently

  Background:
    Given I am a logged-in user

  @javascript
  Scenario: Successfully adding a bin
    When I visit the new bin page
    And I fill in the bin "Name" with "Storage Bin"
    And I fill in the bin "Location" with "Garage"
    And I fill in the bin "bin_category_name" with "Misc"
    And I click "Create Bin"
    Then I should see "Bin was successfully created"
