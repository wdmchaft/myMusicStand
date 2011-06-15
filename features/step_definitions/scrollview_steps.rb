Then /^I see "([^"]*)"$/ do |expectedmark|
  check_element_exists "scrollView marked:'#{expectedmark}'"
end

