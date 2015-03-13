_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Template = require "../templates/item.hbs"

class ItemView extends Backbone.View
  tagName: "article"
  template: Template
  events:
    "click": "click"

  onRender: ->
    @$canvas = @$("canvas")
    @canvas = @$canvas[0]
    @ctx = @canvas.getContext("2d")
    @loadImage()

  loadImage: ->
    @img = new Image()
    @img.src = @model.get("image")
    @img.onload = => @imageLoaded()

  imageLoaded: ->
    @canvas.width = 100
    @canvas.height = 100
    @transform(@ctx, @model.get("matrix"))
    @ctx.drawImage(@img, 0, 0)

  click: ->
    @canvas.width = @img.width * @model.get("offsetHeight")
    @canvas.height = @img.height * @model.get("offsetWidth")
    @transform(@ctx, @model.get("matrix"))
    @ctx.drawImage(@img, (@canvas.width-@img.width)/2, (@canvas.height-@img.height)/2)
    @saveImg()

  saveImg: ->
    data = @canvas.toDataURL("image/png")
    window.location.href = data

  transform: (ctx, matrix) ->
    # call not working.
    ctx.transform(matrix[0], matrix[1], matrix[2], matrix[3], matrix[4], matrix[5])

  render: ->
    @$el.html(@template)
    @onRender()
    @

module.exports = ItemView
