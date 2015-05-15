_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Settings = require "./models/settings"
ImageView = require "./views/image"
ControlsView = require "./views/controls"

$ ->
  img = new Image()
  img.onload = ->
    loadedImage(img.width, img.height)
  img.src = "images/example.png"

loadedImage = (width, height) ->
  settings = new Settings
    width: width
    height: height

  new ImageView(model: settings)
  new ControlsView(model: settings)
