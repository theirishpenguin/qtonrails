Feature: Actor generates KDE app from RESTful Rails app
  In order to have a starting point for building their Ruby KDE app
  Actor should be able to generate a KDE app from a Rails app

  Scenario: Generate from Rails app dependent on no plugins
    Given there is an existing Rails application which has a User model
    And a fully migrated sqlite database containing a users table
    When I run the qtify command
    Then a skeleton KDE app should be generated
