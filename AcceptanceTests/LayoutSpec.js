#import "tuneup_js/test.js"
#import "tuneup_js/assertions.js"

function UILog(message)
{
	UIALogger.logMessage(message);
}

var target = UIATarget.localTarget();

var window = target.frontMostApp().mainWindow();

test("Test Initial Screen", function(){
	 	 
     assertWindow({
                  tableViews: [
							   { name: "Charts"}
                  ]
				  
                 });
	
});