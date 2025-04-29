Feature: Inventory API Tests

Background:
    * url 'http://localhost:3100/api'

Scenario: Get all menu items
    Given path 'inventory'
    When method get
    Then status 200
    And match response.length >= 9
    And match each response contains { id: '#notnull', name: '#notnull', price: '#notnull', image: '#notnull' }

Scenario: Filter by id
    Given path 'inventory/filter'
    And param id = 3
    When method get
    Then status 200
    And match response == { id: 3, name: 'Baked Rolls x 8', price: '$12', image: 'baked_rolls.png' }

Scenario: Add item for non-existent id
    Given path 'inventory/add'
    And request { id: "10", name: "Hawaiian", image: "hawaiian.png", price: "$14" }
    When method post
    Then status 200

Scenario: Add item for existing id
    Given path 'inventory/add'
    And request { id: "10", name: "Hawaiian", image: "hawaiian.png", price: "$14" }
    When method post
    Then status 400

Scenario: Add item with missing information
    Given path 'inventory/add'
    And request { name: "Hawaiian", image: "hawaiian.png", price: "$14" }
    When method post
    Then status 400
    And match response.message == "Not all requirements are met"

Scenario: Validate recently added item is present
    Given path 'inventory'
    When method get
    Then status 200
    And match response[*].id contains 10

