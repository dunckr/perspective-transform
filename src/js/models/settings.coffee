_ = require "underscore"
Backbone = require "backbone"

class Settings extends Backbone.Model

  defaults:
    file: "images/example.png"
    perspective: 600
    rotateX: 0
    rotateY: 0
    rotateZ: 45
    paddingTop: 10
    paddingRight: 0
    paddingBottom: 0
    paddingLeft: 10

module.exports = Settings
