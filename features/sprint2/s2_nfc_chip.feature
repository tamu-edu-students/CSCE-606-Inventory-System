Feature: NFC Chip Scanning for Bin Access
  As a user
  I want to scan the NFC chip
  So that I am redirected to the correct bin page

@javascript
Scenario: A logged-in user scans an NFC tag
    Given I am a logged-in user
    And I have a bin named "Storage Bin" with an NFC link
    When I scan the NFC chip for "Storage Bin"
    Then for NFC, I should be redirected to the bin page for "Storage Bin"

@javascript
Scenario: A logged-out user scans an NFC tag that belongs to him
  Given I am not logged in
  And I have a NFC bin named "Storage Bin" with an NFC link
  When I also scan the NFC chip for "Storage Bin"
  Then I should be redirected to the login page
  When I log in as "test@example.com"
  Then I should be redirected to the bin page for "Storage Bin"

@javascript
Scenario: A logged-out user scans an NFC tag that doesn't belong to him
    Given I am not logged in
    And I found a NFC bin named "Storage Bin" with an NFC link
    When I also scan the NFC chip for "Storage Bin"
    Then I should be redirected to the login page
    When I log in creating new user as "not_me@example.com"
    Then I should be redirected to the page "bins"

