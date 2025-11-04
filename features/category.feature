Feature: Category Management
  As an admin
  I want to manage categories
  So that items can be properly organized

  Background:
    Given the app is in test mode
    And the following users exist:
      | name       | email              | role  |
      | Admin User | admin@example.com  | admin |
    When I sign in with Google

  Scenario: View categories in item creation
    Given the following categories exist:
      | name        | description           |
      | Electronics | Electronic devices    |
      | Books       | Books and magazines   |
    When I visit the new item page
    Then I should see "Electronics" in the category options
    And I should see "Books" in the category options

  Scenario: Category name must be unique
    Given the following categories exist:
      | name        | description           |
      | Electronics | Electronic devices    |
    When I try to create a duplicate category "Electronics"
    Then the category should not be created

  Scenario: Items are destroyed when category is destroyed
    Given the following categories exist:
      | name        | description           |
      | Electronics | Electronic devices    |
    And the following items exist:
      | title     | description | available | user              | category    | for_sale |
      | iPhone 12 | Like new    | true      | admin@example.com | Electronics | true     |
    When the category "Electronics" is destroyed
    Then the item "iPhone 12" should not exist
