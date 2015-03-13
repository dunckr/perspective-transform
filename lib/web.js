framework('WebKit');
framework('AppKit');

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
  var screenFrame = NSScreen.mainScreen().frame();
  var screenWidth = screenFrame.size.width;
  var screenHeight = screenFrame.size.height;
  var frame = NSMakeRect(0, 0, screenWidth, screenHeight);

  var webView = WebView.alloc().initWithFrame(frame);
  var webViewFrame = webView.mainFrame();

  var URL = NSURL.URLWithString(htmlPath());
  var request = NSURLRequest.requestWithURL(NSURL.URLWithString(htmlPath()));
  webViewFrame.loadRequest(request);

  // Set up the panel window
  var mask = NSTitledWindowMask + NSClosableWindowMask + NSMiniaturizableWindowMask + NSResizableWindowMask + NSUtilityWindowMask;
  var panel = NSPanel.alloc().initWithContentRect_styleMask_backing_defer(frame, mask, NSBackingStoreBuffered, true);

  // Add the webView to the prepared panel
  panel.contentView().addSubview(webView);

  // Show the panel
  panel.makeKeyAndOrderFront(panel);

  // persist the panel and the webView
  persist.set('panel', panel);
  persist.set('webView', webView);
}
