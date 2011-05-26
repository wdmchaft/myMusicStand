When /^I touch the "([^\"]*)" nav bar button$/ do |mark|
  touch( "navigationButton marked:'#{mark}'" )
end
