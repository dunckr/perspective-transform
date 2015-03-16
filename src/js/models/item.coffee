_ = require "underscore"
Backbone = require "backbone"

class Item extends Backbone.Model

  defaults:
    image: "images/example.png?#{new Date().getTime()}"
    points:
      [
        { x: -0.859999984741211, y: 0.7514792899408285 }
        { x: 0.9159999999999999, y: 0.7199211045364892 }
        { x: -0.7879999847412109, y: -0.8303747534516766}
        { x: 0.23199999999999998, y: -0.5857988165680474 }
      ]

module.exports = Item
