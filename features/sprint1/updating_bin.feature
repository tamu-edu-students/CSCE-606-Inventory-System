  Feature: NFC Chip Scanning for Bin Access
    As a user
    I want to update a bin
    So that I can modify its details
  
  Background:
    Given I am a logged-in user
    And I have a bin named "Storage Bin"

  @javascript
  Scenario: Updating the bins
    When I visit the edit page for "Storage Bin"
    And I fill in the bin name with "Updated Bin"
    And I press "Update Bin"
    Then I should see "Bin was successfully updated"
    And I should see "Updated Bin" on the bins list