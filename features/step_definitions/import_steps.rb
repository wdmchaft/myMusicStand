When /^I import "([^"]*)"$/ do |filename|
  FileUtils.copy "/Users/stevesolomon/Desktop/music/charts/" + filename,
                "/Users/stevesolomon/Library/Application Support/iPhone Simulator/4.3.2/Applications/E66F5374-7F33-4982-86B0-0F800813F389/Documents/" + filename

  press_home_on_simulator
  simulator_hardware_menu_press APP_NAME	
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
