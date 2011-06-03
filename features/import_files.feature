Feature: The users must be able to import files into myMusicStand by 
		 adding files to the app documents directory. This is primarily done
		 using iTunes sync

Scenario: Launch the app for the first time
	Given I reset the ipad app 
	And I see an empty "Charts" table
	When I import "No Doubt-Sunday Morning-Sheetzbox.pdf"
	Then I should see "No Doubt-Sunday Morning-Sheetzbox.pdf" block
	And I should see "No Doubt-Sunday Morning-Sheetzbox.pdf" label


Scenario: Scroll through pages in PDF
  When I tap "No Doubt-Sunday Morning-Sheetzbox.pdf"
  Then I see "Page 1"
  When I scroll Left
  Then I see "Page 2"
  When I scroll Left
  Then I see "Page 3"
  When I scroll Left
  Then I see "Page 4"
  When I scroll Left
  Then I see "Page 5"
  When I scroll Left
  Then I see "Page 6"
  When I scroll Left
  Then I see "Page 7"
  When I scroll Left
  Then I see "Page 8"
  When I scroll Left
  Then I see "Page 8"
  When I scroll Right
  And I scroll Right
  And I scroll Right
  And I scroll Right
  And I scroll Right
  And I scroll Right
  And I scroll Right
  And I scroll Right
  Then I see "Page 1"
  When I scroll Right
  Then I see "Page 1"
  When I tap the screen
  And I tap "Charts" navigationButton
  Then I should see "No Doubt-Sunday Morning-Sheetzbox.pdf" block
  And I should see "No Doubt-Sunday Morning-Sheetzbox.pdf" label


