#import "tuneup_js/test.js"
#import "tuneup_js/assertions.js"

function UILog(message)
{
	UIALogger.logMessage(new String(message));
}

var target = UIATarget.localTarget();
var window = target.frontMostApp().mainWindow();

// Set our orientation to Portrait
target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);

// Breadth first search
function assertExists(topElement, goalFunction)
{
	// Create a to expand queue
	var toExpand = new Array(topElement);
	// Create a expaneded queue
	var expanded = new Array(topElement);
	
	// While the to expand queue has vertices 
	while (toExpand.length > 0)
	{
		// Grab a vertex
		var vertex = toExpand.shift();
		
		UILog(vertex);
		
		var elements = vertex.elements().toArray();
		
		UILog((elements != null) ? "Sweet" : "No");
		
		// loop through all children of this vertex
		for (element in elements)
		{			
			UILog("Element");
			
			// Check if we have a goal element
			if (goalFunction(element))
			{
				return element;
			}
			
			// if the element hasn't been expanded
			if (expanded.indexOf(element) != -1)
			{
				toExpand.push(element);
			}
		}
		
		// if we get here we never found the goal element
		return null;
	}
}

assertExists(window, function(element){
				return true;
			 });

test("Test Initial Screen", function(){
	 	 
     assertWindow({
                  tableViews: [
							   { name: "Charts"},
                  ],
				  navigationBars: [
				  			{ name: "Bottom of Stand" }
				  ]				  
                 });
	
});