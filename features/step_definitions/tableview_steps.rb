Given /^I see an empty table$/ do
  check_element_exists( "tableView marked:'Empty list'" )
end

Then /^I should see "([^"]*)" block$/ do |expectedmark|
  check_element_exists "tableView tableViewCell view marked:'#{expectedmark} block'"
end

Then /^I should see "([^"]*)" label$/ do |expectedmark|
  check_element_exists "tableView tableViewCell label marked:'#{expectedmark}'"
end

Given /^I see a table with no rows$/ do
  tableCells = frankly_map "tableView tableViewCell", "tag"
  tableCells.count.should == 0
end

Given /^I see an empty "([^"]*)" table$/ do |mark|
  tableCells = frankly_map "tableView marked:'#{mark}' tableViewCell", "tag"
  tableCells.count.should == 0
end

Then /^I should see "([^"]*)" table$/ do |expectedmark|
  check_element_exists "tableView marked:'#{expectedmark}'"
end
