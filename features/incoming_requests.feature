Feature: Incoming Requests
  As a seller
  I want to view requests for my items
  So that I can approve or reject them

  Background:
    Given the app is in test mode
    And the following users exist:
      | name        | email              | role   |
      | Buyer User  | buyer@example.com  | member |
    And the following categories exist:
      | name        | description           |
      | Electronics | Electronic devices    |

    # Sign in as the seller (New Student from OmniAuth mock: new@student.edu)
    When I sign in with Google

    And the following items exist:
      | title          | description   | available | user             | category    | for_sale |
      | USB-C Monitor | 4K, like new  | true      | new@student.edu  | Electronics | true     |
    And the following items exist:
      | title       | description | available | user             | category    | for_sale |
      | Old Laptop  | Works fine  | true      | new@student.edu  | Electronics | true     |

    # Create pending requests from buyer to the seller's items
    And the following requests exist:
      | item_title    | requester_email   | status  | message                 |
      | USB-C Monitor | buyer@example.com | pending | Interested in buying.   |
      | Old Laptop    | buyer@example.com | pending | Can you lower the price?|

  Scenario: View incoming requests list and approve one
    When I visit the incoming requests page for "new@student.edu"
    Then I should see "Requests For My Items"
    And I should see "USB-C Monitor"
    And I should see "Old Laptop"
    And I should see "Buyer User"

    # Approve the first request using the button_to form
    When I click the first "Approve" button
    Then I should see "Request approved."
