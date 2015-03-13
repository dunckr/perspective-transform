framework('WebKit')
framework('AppKit')

function scriptPath() {
	var scriptpath = sketch.scriptPath.split('/');
	scriptpath.pop();
	return scriptpath.join('/') + '/';
}

function htmlPath() {
	return encodeURI('file://' + scriptPath() + 'build/index.html');	
}

// need to save the current selected item to img...

function setupWebView() {
	var screenFrame = [[NSScreen mainScreen] frame]
	var screenWidth = screenFrame.size.width
	var screenHeight = screenFrame.size.height
	var frame = NSMakeRect(0, 0, screenWidth, screenHeight)
	var webView = WebView.alloc().initWithFrame(frame)
	var webViewFrame = webView.mainFrame()

	webViewFrame.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(htmlPath())))

	// Set up the panel window
	var mask = NSTitledWindowMask + NSClosableWindowMask + NSMiniaturizableWindowMask + NSResizableWindowMask + NSUtilityWindowMask
	var panel = NSPanel.alloc().initWithContentRect_styleMask_backing_defer(frame, mask, NSBackingStoreBuffered, true)

	// Add the webView to the prepared panel
	panel.contentView().addSubview(webView)

	// Show the panel
	panel.makeKeyAndOrderFront(panel)

	// persist the panel and the webView.
	persist.set('panel', panel)
	persist.set('webView', webView)
}


// function screenshot() {

// 	var webView = persist.get('webView')

// 	var frame = NSMakeRect(0, 0, 600, 480);
// 	var originRect = [webView convertRect:[webView bounds] toView:[[webView window] contentView]];
// 	// var captureRect = originRect;
// 	// captureRect.origin.x += frame.origin.x;
// 	// captureRect.origin.y = frame.size.height -
// 	//                        frame.origin.y -
// 	//                        originRect.origin.y -
// 	//                        originRect.size.height;
// 	// var imageRef = CGWindowListCreateImage(captureRect,
// 	var imageRef = CGWindowListCreateImage(originRect,
// 	                                             kCGWindowListOptionIncludingWindow,
// 	                                             [[webView window] windowNumber],
// 	                                             kCGWindowImageDefault);
	
// 	var image = [[NSImage alloc] initWithCGImage: imageRef size: NSZeroSize];

// 	var layer = selection[0]
//     var fill = layer.style().fills().firstObject();
//     fill.setFillType(4);
//     fill.setPatternImage(image);
//     fill.setPatternFillType(1);
// }

// function saveToImage() {}