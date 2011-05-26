Feature: The users must be able to import files into myMusicStand by 
		 adding files to the app documents directory. This is primarily done
		 using iTunes sync

Scenario: Launch the app for the first time
	Given I reset the ipad app 
	And I see an empty table
