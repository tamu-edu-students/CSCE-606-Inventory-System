Feature: QR Code Scanning for Bins
  As a user
  I want to scan a QR code
  So that I am redirected to the correct bin page

  @javascript
  Scenario: User scans a QR code and is redirected to the bin
    Given I am a logged-in user
    And I have a valid location
    And I have a bin named "Storage Bin" with a QR code
    When I scan the QR code for "Storage Bin"
    Then I should be redirected to the bin page for "Storage Bin"
