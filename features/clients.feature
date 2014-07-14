Feature: Clients pages
  Scenario: Display clients list
    Given I am logged in
    When I visit the clients page
    Then I should see the list of clients
