Given /^I launch the (ipad|iphone) app$/ do |device|

  # kill the app if it's already running, just in case this helps 
  # reduce simulator flakiness when relaunching the app. Use a timeout of 5 seconds to 
  # prevent us hanging around for ages waiting for the ping to fail if the app isn't running
  begin
    Timeout::timeout(5) { press_home_on_simulator if frankly_ping }
  rescue Timeout::Error 
  end

  require 'sim_launcher'

  app_path = ENV['APP_BUNDLE_PATH'] || APP_BUNDLE_PATH
  raise "APP_BUNDLE_PATH was not set. \nPlease set a APP_BUNDLE_PATH ruby constant or environment variable to the path of your compiled Frankified iOS app bundle" if app_path.nil?

  if( ENV['USE_SIM_LAUNCHER_SERVER'] )
    @simulator = SimLauncher::Client.for_ipad_app( app_path, "4.3" )
  else
    @simulator = SimLauncher::DirectClient.for_ipad_app( app_path, "4.3" )
  end
  
  num_timeouts = 0
  loop do
    begin
      @simulator.relaunch
      wait_for_frank_to_come_up
      break # if we make it this far without an exception then we're good to move on

    rescue Timeout::Error
      num_timeouts += 1
      puts "Encountered #{num_timeouts} timeouts while launching the app."
      if num_timeouts > 3
        raise "Encountered #{num_timeouts} timeouts in a row while trying to launch the app." 
      end
    end
  end

  # TODO: do some kind of waiting check to see that your initial app UI is ready
  # e.g. Then "I wait to see the login screen"

end

Given /^I reset the (iphone|ipad) app$/ do |device|
  steps "When I quit the simulator"
  SDK    = "4.3.2"
  APPLICATIONS_DIR = "/Users/#{ENV['USER']}/Library/Application Support/iPhone Simulator/#{SDK}/Applications"
  
  USERDEFAULTS_PLIST = "Library/Preferences/com.yourcompany.#{APP_NAME}.dist.plist"
  
  Dir.foreach(APPLICATIONS_DIR) do |item|
    next if item == '.' or item == '..'
    if File.exists?( "#{APPLICATIONS_DIR}/#{item}/#{USERDEFAULTS_PLIST}")
      FileUtils.rm "#{APPLICATIONS_DIR}/#{item}/#{USERDEFAULTS_PLIST}" 
    end
  end

  # Remove all documents 
  DOCUMENTS_DIR = "/Users/stevesolomon/Library/Application Support/iPhone Simulator/4.3.2/Applications/5A8CEE17-1083-4777-89BC-DCB12E0DF016/Documents"

  FileUtils.rm_rf DOCUMENTS_DIR  
 
  # Remove SQLite3 DB
  DB_PATH = "/Users/stevesolomon/Library/Application Support/iPhone Simulator/4.3.2/Applications/5A8CEE17-1083-4777-89BC-DCB12E0DF016/Library/myMusicStand.sqlite"
  FileUtils.rm_f DB_PATH 
  
  steps "Given I launch the #{device} app"
end

When /^I launch the app$/ do
  @simulator.relaunch
  wait_for_frank_to_come_up
end
