Feature: Actor generates Qt app from RESTful Rails app
  In order to have a starting point for building their Ruby Qt app
  Actor should be able to generate a Qt app from a Rails app

  Scenario: Generate from Rails app dependent on no plugins
    Given there is an existing Rails application which has a User model
    And a fully migrated sqlite database containing a users table
    When I run the qtify command
    Then a skeleton Qt app should be generated

  #Scenario: Generate from Rails app dependent on a plugin

  #Scenario: Generate from Rails app who's model points to a remote ActiveResource
  #Note: May no be possible

  #Scenario: Generate from Rails app which needs to display validation errors
