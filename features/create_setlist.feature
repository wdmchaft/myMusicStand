Feature: Create Setlist
  In order to group charts
  As a user 
  I can create a setlist and charts to it

Background: 
  Given I reset the ipad app

Scenario: Create an empty Setlist
  Given I touch the segment marked "Sets" 
  When I touch "Add Setlist block" 
  Then I should see "Unnamed Set" block
  And I should see "Unnamed Set" label
