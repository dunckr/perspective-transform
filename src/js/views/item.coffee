_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Template = require "../templates/item.hbs"

class ItemView extends Backbone.View
  MIN_SIZE: 300
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
    @canvas.width = @MIN_SIZE
    @canvas.height = @MIN_SIZE
    @transform()
    @ctx.drawImage(@img,
      #0, 0, @img.width, @img.height
      0, 0, (@canvas.width/2), (@canvas.height/2)
    )
    #@ctx.drawImage(@img,
      #0, 0, @img.width, @img.height,
      #0, 0, (@canvas.width/2), (@canvas.height/2)
    #)

  click: ->
    @canvas.width = @img.width * @model.get("offsetHeight")
    @canvas.height = @img.height * @model.get("offsetWidth")
    @transform()
    @ctx.drawImage(@img,
      (@canvas.width-@img.width)/2,
      (@canvas.height-@img.height)/2
    )
    @saveImg()

  saveImg: ->
    data = @canvas.toDataURL("image/png")
    window.location.href = data

  transform: ->
    # call not working.
    matrix = @model.get("matrix")
    @ctx.transform(matrix[0], matrix[1], matrix[2], matrix[3], matrix[4], matrix[5])

  render: ->
    @$el.html(@template)
    @onRender()
    @

module.exports = ItemView
