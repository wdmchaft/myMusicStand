#import "tuneup_js/test.js"
#import "tuneup_js/assertions.js"

var target = UIATarget.localTarget();

var window = target.frontMostApp().mainWindow();

test("Test Initial Screen", function(){
	 // Check charts table exists
	 table = window.tableViews()[0];
	 assertEquals("Charts", table.name());
	 
	 window.logElementTree();
	 bottomOfStand = window
	
});