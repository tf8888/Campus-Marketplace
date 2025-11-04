Feature: Message Model Validations
  As a developer
  I want to ensure messages are properly validated
  So that data integrity is maintained

  Background:
    Given the app is in test mode
    And the following users exist:
      | name       | email              | role   |
      | Buyer User | buyer@example.com  | member |
      | Item Owner | owner@example.com  | member |
    And the following categories exist:
      | name        | description           |
      | Electronics | Electronic devices    |
    And the following items exist:
      | title     | description | available | user              | category    | for_sale |
      | Laptop    | Works great | true      | owner@example.com | Electronics | true     |
    And the following requests exist:
      | item_title | requester_email   | status  | message              |
      | Laptop     | buyer@example.com | pending | Interested in buying |

  Scenario: Cannot create message with same sender and receiver
    When I try to create a message with sender and receiver "buyer@example.com" for request "Laptop"
    Then the message should be invalid with error "can't be the same as sender"

  Scenario: Cannot create message without content
    When I try to create a message without content for request "Laptop"
    Then the message should be invalid with error "can't be blank"

  Scenario: Cannot create message with content longer than 500 characters
    When I try to create a message with 501 characters for request "Laptop"
    Then the message should be invalid with error "too long"
