Feature: Actor generates Qt app from RESTful Rails app
  In order to have a starting point for building their Ruby Qt app
  Actor should be able to generate a Qt app from a Rails app

  Scenario: Generate from Rails app dependent on no plugins
    Given there is an existing Rails application which has a User model
    And a fully migrated sqlite database containing a users table
    When I run the qtify command
    Then a skeleton Qt app should be generated

  Scenario: Generate from Rails app with a model containing a date, time and datetime
    Given there is an existing Rails application which has a Event model
    And a fully migrated sqlite database containing a events table
    And the attributes: slot (time), scheduled_date (date) and future_party_datetime (datetime)
    When I run the qtify command
    Then a skeleton Qt app should be generated
    And the ability to edit the Event model attributes slot (time edit), scheduled_date (date edit) and future_party_datetime (datetime edit) with appropriate in-grid widgets
    And the ability to create the Event model attributes slot (time edit), scheduled_date (date edit) and future_party_datetime (datetime edit) with appropriate form fields
    And the ability to edit the Event model attributes slot (time edit), scheduled_date (date edit) and future_party_datetime (datetime edit) with appropriate form fields
    And the ability to view the Event model attributes slot (time edit), scheduled_date (date edit) and future_party_datetime (datetime edit) with appropriate form fields

  #Scenario: Generate from Rails app dependent on a plugin

  #Scenario: Generate from Rails app who's model points to a remote ActiveResource
  #Note: May no be possible

  #Scenario: Generate from Rails app which needs to display validation errors
