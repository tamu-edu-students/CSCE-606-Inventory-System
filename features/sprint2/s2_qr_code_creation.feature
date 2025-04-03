Feature: QR Code Generation for Bins
  As a user
  I want to create a bin
  So that it generates a QR code automatically

  @javascript
  Scenario: User creates a bin and sees the QR code
    Given I am a logged-in user
    When I visit the new bin page
    And I fill in the bin "Name" with "Storage Bin"
    And I fill in the bin "Location" with "Garage"
    And I fill in the bin "bin_category_name" with "Misc"
    And I click "Create Bin"
    Then I should see the bin success message "Bin was successfully created."
    And I should see a QR code
