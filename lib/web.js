framework('WebKit');

function scriptPath() {
  var scriptpath = sketch.scriptPath.split('/');
  scriptpath.pop();
  return scriptpath.join('/') + '/';
}

function htmlPath() {
  return encodeURI('file://' + scriptPath() + 'build/index.html');
}

function saveSelectionToImage() {
  var flattener = MSLayerFlattener.alloc().init();
  flattener.flattenLayers(selection);
  var layer = selection.firstObject();
  log(layer)
  if (layer) {
    var frame = layer.frameInArtboard();
    var filePath = scriptPath() + 'build/images/' + 'example' + '.png';
    log(filePath)
    doc.saveArtboardOrSlice_toFile(frame, filePath);
    setupWebView()
  }
}

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
  var mask = NSTitledWindowMask + NSClosableWindowMask + NSMiniaturizableWindowMask + NSResizableWindowMask + NSUtilityWindowMask;
  var panel = NSPanel.alloc().initWithContentRect_styleMask_backing_defer(frame, mask, NSBackingStoreBuffered, true);
  panel.contentView().addSubview(webView);
  panel.makeKeyAndOrderFront(panel);
  persist.set('panel', panel);
  persist.set('webView', webView);
}
