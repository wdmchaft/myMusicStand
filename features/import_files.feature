Feature: The users must be able to import files into myMusicStand by 
		 adding files to the app documents directory. This is primarily done
		 using iTunes sync

Scenario: Launch the app for the first time
	Given I reset the ipad app 
	And I see an empty "Charts" table
	When I import "No Doubt-Sunday Morning-Sheetzbox.pdf"
	Then I should see "No Doubt-Sunday Morning-Sheetzbox.pdf" block
	And I should see "No Doubt-Sunday Morning-Sheetzbox.pdf" label
