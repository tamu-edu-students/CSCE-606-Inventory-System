Feature: Authentication redirection

  Background:
    Given a user named "Alice" with email "alice@example.com" and password "Password1!"

  @javascript
  Scenario: Logged-in user visits login page
    Given I am logged in session as "alice@example.com"
    When I visit the login page
    Then I should be redirected to the dashboard session
    And I should see "You are already signed in."

  @javascript
  Scenario: Unauthenticated user is redirected from dashboard
    When I visit the dashboard pagex
    Then I should see "You need to sign in or sign up before continuing."

