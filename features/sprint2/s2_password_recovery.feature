Feature: Password Recovery
  As a user
  I want to recover my password
  So that I can log in if I forget it

  Background:
    Given I am a registered user with email "test@example.com" and password "Password123!"

  @javascript
  Scenario: Requesting a password reset
    Given I am on the forgot password page
    When I enter my email "test@example.com"
    And I press the "Send Reset Code"
    Then I should see the "Reset code sent to your email" s2

  @javascript
  Scenario: Entering a valid reset code
    Given I have requested a password reset
    And I received a reset code via email
    When I enter the reset code
    And I press "Verify"
    Then I should be redirected to the password reset page
    And I should see "New Password"

  @javascript
  Scenario: Resetting the password successfully
    Given I have entered a valid reset code
    When I enter "NewPassword1!" as my new password
    And I confirm "NewPassword1!" as my new password
    And I press "Reset Password"
    Then I should see the "Password reset successful!" s2
    And I should be redirected to the login page1

  @javascript
  Scenario: Entering an invalid reset code
    Given I have requested a password reset
    When I enter an invalid reset code
    And I press "Verify"
    Then I should see the "Invalid or expired reset code" s2

  @javascript
  Scenario: Trying to use an expired reset code
    Given I have requested a password reset
    And my reset code has expired
    When I enter the reset code
    And I press "Verify"
    Then I should see the "Invalid or expired reset code" s2
    And I should be redirected to the forgot password page

  @javascript
  Scenario: Trying to reset password with mismatched confirmation
    Given I have entered a valid reset code
    When I enter "NewPassword1!" as my new password
    And I confirm "WrongPassword!" as my new password
    And I press "Reset Password"
    Then I should see the "Passwords don't match" s2.1

  @javascript
  Scenario: Trying to reset password with an invalid format
    Given I have entered a valid reset code
    When I enter "password" as my new password
    And I confirm "password" as my new password
    And I press "Reset Password"
    Then I should see the "Password must include at least one uppercase letter" s2
    And I should see the "Password must include at least one number"
    And I should see the "Password must include at least one special character"

