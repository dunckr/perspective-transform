_ = require "underscore"
Backbone = require "backbone"

class Item extends Backbone.Model

  defaults:
    image: "images/example.png"
    matrix: [1, -0.08, 0, 1, 0, 50]
    offsetHeight: 1.4
    offsetWidth: 1.4

module.exports = Item
