Feature: User login with Google
  As a visitor
  I want to sign in with Google
  So that I can access the app

  Background:
    Given the app is in test mode

  Scenario: Redirects unauthenticated users to login page
    When I visit the home page
    Then I should be on the login page
    And I should see the alert "You must sign in first."

  Scenario: Successful sign in with Google
    When I sign in with Google
    Then I should be on the home page
    And I should see "Signed in as New Student"
    And I should see "Hello, New Student"

  Scenario: Logout redirects to login and shows notice
    When I sign in with Google
    And I click "Logout"
    Then I should be on the login page
    And I should see the alert "You must sign in first."
    And I should not see "Logout"

  Scenario: OAuth failure redirects to login with alert
    When I visit the OAuth failure callback
    Then I should be on the login page
    And I should see the alert "You must sign in first."
