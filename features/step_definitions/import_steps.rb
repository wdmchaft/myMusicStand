
app_path_docs = "/Users/stevesolomon/Library/Application Support/iPhone " + 
				"Simulator/4.3.2/Applications/" +
                "7E848F0C-6B13-456A-BB72-9A1BF591E579/Documents/"

Given /^I remove all files from the app documents$/ do
	# Loop over all files in docs directory and remove them
	Dir[app_path_docs + "*"].each do |file| 
		FileUtils.rm file
	end 	
end

When /^I add '([^\"]*)' to documents$/ do |file|
	charts_path = "/Users/stevesolomon/Desktop/music/charts/"

	# copy the file from our charts directory to docs directory	
	FileUtils.cp charts_path + file, app_path_docs + file

	# the following code closes and then resets the simulator
	# this is to simulate the reloading of the app that 
	# occurs when iTunes syncs documents 
	press_home_on_simulator
	simulator_hardware_menu_press "myMusicStand copy"
	wait_for_frank_to_come_up
end

Then /^I should see '([^\"]*)' in the table$/ do |file|
	check_element_exists( "tableView tableViewCell first view label text:'#{file}'" )
end
