Given /^I see an empty table$/ do
  check_element_exists( "tableView marked:'Empty list'" )
end

Then /^I should see "([^"]*)" block$/ do |expectedMark|
  check_element_exists "tableView tableViewCell view marked:'{#expectedMark}'"
end

Given /^I see an empty "([^"]*)" table$/ do |expectedMark|
  check_element_exists "tableView marked:'{#expectedMark}'"
  
  tableCells = frankly_map "tableView tableViewCell all"

  raise "there shouldn't be any table cells" if !tableCells.empty?
end

