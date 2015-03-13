var persist = {
  dict: NSThread.mainThread().threadDictionary(),

  get: function(key) {
    var val = this.dict[key];
    if (val !== null && val.className() === '__NSCFString') {
      val = JSON.parse(val);
    }
    return val;
  },

  set: function(key, val) {
    if (Object.prototype.toString.call(val) !== '[object MOBoxedObject]') {
      val = JSON.stringify(val);
    }
    this.dict[key] = val;
  }
};
