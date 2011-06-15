When /^I tap "([^"]*)"$/ do |mark|
  touchxy "view marked:'#{mark} block'", 100, 136 
end

def touchxy( uiquery, x, y ) 
  views_touched = frankly_map( uiquery, 'touchx:y:', "#{x}", "#{y}"  ) 
  raise "no matching [#{uiquery}] to touch" if views_touched.empty? 
end 

Given /^I touch the segment marked "([^"]*)"$/ do |mark|
  touch "view:'UISegment' marked:'#{mark}'" 
end

When /^Pan From Right to Left$/ do
  panFromXYtoXY "view marked:'Page 1'", 656, 500, 80, 500 
end

def panFromXYtoXY( uiquery, x, y, xprime, yprime)
  views_panned = frankly_map uiquery, 'panFromX:Y:toX:Y:', "#{x}", "#{y}",
				    	     "#{xprime}", "#{yprime}"
  raise "no matching [#{uiquery}] to pan" if views_panned.empty?
end
