_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Template = require "../templates/item.hbs"

class ItemView extends Backbone.View

  template: Template
  events:
    "click": "click"

  initialize: ->

  onRender: ->
    @$canvas = @$("canvas")
    @canvas = @$canvas[0]

    @img = new Image()
    @img.src = @model.get("image")
    @img.onload = =>
      @canvas.width = 100
      @canvas.height = 100
      @ctx = @canvas.getContext("2d")
      @ctx.transform(1, -0.08, 0, 1, 0, 50)
      @ctx.drawImage(@img, 0, 0)

  click: ->
    @canvas.width = @img.width * @model.get("offsetHeight")
    @canvas.height = @img.height * @model.get("offsetWidth")
    @ctx = @canvas.getContext("2d")
    @ctx.transform(1, -0.08, 0, 1, 0, 50)
    @ctx.drawImage(@img, (@canvas.width-@img.width)/2, (@canvas.height-@img.height)/2)
    @saveImg()

  saveImg: ->
    data = @canvas.toDataURL("image/png")
    window.location.href = data

  render: ->
    @$el.html(@template)
    @onRender()
    @

module.exports = ItemView
