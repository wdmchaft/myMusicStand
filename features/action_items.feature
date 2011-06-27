Feature: Action Items 
  In order to perform actions with arrangements
  As a user
  I want to be able to select arrangements

  Background: 
	Given I reset the ipad app
  
  Scenario: Delete Arrangement
 	Given I import "No Doubt-Sunday Morning-Sheetzbox.pdf" 
	When I touch the button marked "Action Items"
	Then I should see delete button and done button
  
