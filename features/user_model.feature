Feature: User model validations
  In order to maintain data integrity
  The user model should validate required fields and uniqueness

  Background:
    Given there are no users

  Scenario: Requires email
    When I validate a new user with:
      | name  | Alice |
    Then the user should be invalid
    And the error on "email" should include "can't be blank"

  Scenario: Enforces unique email
    Given a user exists with:
      | name  | Alice               |
      | email | alice@example.edu   |
    When I validate a new user with:
      | name  | Another Alice       |
      | email | alice@example.edu   |
    Then the user should be invalid
    And the error on "email" should include "has already been taken"

  Scenario: Requires name
    When I validate a new user with:
      | email | bob@example.edu |
    Then the user should be invalid
    And the error on "name" should include "can't be blank"
