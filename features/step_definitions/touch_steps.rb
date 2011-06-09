When /^I tap "([^"]*)"$/ do |mark|
  touchxy "view marked:'#{mark} block'", 100, 136 
end

def touchxy( uiquery, x, y ) 
  puts "I got here #{x}, #{y}"
  views_touched = frankly_map( uiquery, 'touchx:y:', "#{x}", "#{y}"  ) 
  raise "no matching [#{uiquery}] to touch" if views_touched.empty? 
end 

Given /^I touch the segment marked "([^"]*)"$/ do |mark|
  touch "view:'UISegment' marked:'#{mark}'" 
end
