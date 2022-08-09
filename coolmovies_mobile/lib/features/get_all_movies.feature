Feature: Fetch all movies from database
As a user I need to check the available movies

Scenario: Internet
Given user has connection
When requesting to get all movies 
App should fetch the movie list ✅
And then cache the results ✅

Scenario: No internet
Given user has no connection with the internet
When requesting to get all movies 
App should load the last captured list of movies ✅
App should warn user of the connection and explicit results are from cache✅
