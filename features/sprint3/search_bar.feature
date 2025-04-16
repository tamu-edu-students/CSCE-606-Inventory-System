Feature: Search Bars on Dashboard
  As a user of the website,
  I want to have two separate search bars,
  So that I can quickly find my bins/categories and items.

  Background:
    Given I am a logged-in user on the dashboard
    And I have a valid location
    And I have bins with names "Storage Bin" and "Office Supplies" 
    And I have items with names "drill" and "screwdriver" on bin "Storage Bin"
    And I have items with names "staple" and "eraser" on bin "Office Supplies"



  ### ✅ SEARCH BAR FOR BINS/CATEGORIES ##
  
  @javascript
  Scenario: Searching for a bin by name
    When I enter "Storage Bin" in the bins search bar
    And I click the bins search button
    Then I should see bins matching "Storage Bin"

  @javascript
  Scenario: Searching for a category
    When I enter "tech" in the bins search bar
    And I click the bins search button
    Then I should see categories matching "tech"

  @javascript
  Scenario: No results found for bins/categories
    When I enter "NonExistentBin" in the bins search bar
    And I click the bins search button
    Then I should see the message on the screen "No bins yet"

  @javascript
  Scenario: Searching for an item by name
    When I enter "drill" in the items search bar
    And I click the items search button
    Then I should see items matching "drill"

  @javascript
  Scenario: No results found for items
    When I enter "NonExistentItem" in the items search bar
    And I click the items search button
    Then I should see a message "No items yet"



