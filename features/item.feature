Feature: Item Management
  As a user
  I want to manage items
  So that I can list, search, and interact with items

  Background:
    Given the following users exist:
      | name        | email              | role    |
      | John Doe    | john@example.com   | member  |
      | Jane Smith  | jane@example.com   | member  |
    And the following categories exist:
      | name        | description           |
      | Electronics | Electronic devices    |
      | Books       | Books and magazines   |
      | Furniture   | Home furniture        |
    And I am logged in as "john@example.com"


  Scenario: Cannot create item with both for_sale and for_lend
    When I visit the new item page
    And I fill in the item form with:
      | field       | value           |
      | Title       | Gaming Console  |
      | Description | PS5             |
      | Condition   | New             |
      | Category    | Electronics     |
    And I check "For Sale"
    And I check "For Lend"
    And I submit the item form
    Then I should see "Item must be either for sale or for lend, not both or neither"

  Scenario: Cannot create item with neither for_sale nor for_lend
    When I visit the new item page
    And I fill in the item form with:
      | field       | value           |
      | Title       | Gaming Console  |
      | Description | PS5             |
      | Condition   | New             |
      | Category    | Electronics     |
    And I submit the item form
    Then I should see "Item must be either for sale or for lend, not both or neither"

  Scenario: Empty search returns no items
    Given the following items exist:
      | title     | description | available | user             | category    | for_sale |
      | iPhone 12 | Like new    | true      | john@example.com | Electronics | true     |
    When I visit the items page
    Then I should not see "iPhone 12"

  Scenario: Cannot edit someone else's item
    Given the following items exist:
      | title     | description | available | user             | category    | for_sale |
      | iPhone 12 | Like new    | true      | jane@example.com | Electronics | true     |
    When I try to visit the edit page for "iPhone 12"
    Then I should see "You are not authorized to modify this item"
    And I should be on the items page


  Scenario: Cannot delete someone else's item
    Given the following items exist:
      | title     | description | available | user             | category    | for_sale |
      | iPhone 12 | Like new    | true      | jane@example.com | Electronics | true     |
    When I try to delete the item "iPhone 12"
    Then I should see "You are not authorized to modify this item"
    And the item "iPhone 12" should still exist


  Scenario: Cannot view unavailable item if not owner
    Given the following items exist:
      | title     | description | available | user             | category    | for_sale |
      | iPhone 12 | Like new    | false     | jane@example.com | Electronics | true     |
    When I try to visit the item page for "iPhone 12"
    Then I should see "This item is no longer available"
    And I should be on the items page

  Scenario: Title validation - cannot be blank
    When I visit the new item page
    And I fill in the item form with:
      | field       | value       |
      | Description | Test item   |
      | Category    | Electronics |
    And I check "For Sale"
    And I submit the item form
    Then I should see an error message about title

  Scenario: Title validation - maximum length
    When I visit the new item page
    And I fill in "Title" with a string of 101 characters
    And I fill in "Category" with "Electronics"
    And I check "For Sale"
    And I submit the item form
    Then I should see an error message about title length

  Scenario: Description validation - maximum length
    When I visit the new item page
    And I fill in the item form with:
      | field    | value       |
      | Title    | Test Item   |
      | Category | Electronics |
    And I fill in "Description" with a string of 1001 characters
    And I check "For Sale"
    And I submit the item form
    Then I should see an error message about description length