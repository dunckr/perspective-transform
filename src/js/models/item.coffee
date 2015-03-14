_ = require "underscore"
Backbone = require "backbone"

class Item extends Backbone.Model

  defaults:
    image: "images/example.png?#{new Date().getTime()}"
    matrix: [1, -0.08, 0, 1, 0, 50]
    offsetHeight: 1.2
    offsetWidth: 1.2

module.exports = Item
