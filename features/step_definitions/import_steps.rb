When /^I import "([^"]*)"$/ do |filename|
  FileUtils.copy "/Users/stevesolomon/Desktop/music/charts/" + filename,
                "/Users/stevesolomon/Library/Application Support/iPhone Simulator/4.3.2/Applications/5A8CEE17-1083-4777-89BC-DCB12E0DF016/Documents/" + filename

  press_home_on_simulator
  steps "Given I launch the app"
end


def press_home_on_simulator 
  simulator_hardware_menu_press "Home" 
end 
 
def simulator_hardware_menu_press( menu_label ) 
  %x{osascript<<APPLESCRIPT 
    activate application "iPhone Simulator" 

    tell application "System Events" 
      click menu item "#{menu_label}" of menu "Hardware" of menu bar of process "iPhone Simulator" 
    end tell 
  APPLESCRIPT}   
end 

