_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Template = require "../templates/image.hbs"
rasterizeHTML = require "rasterizehtml"

class ImageView extends Backbone.View

  el: "#canvas"
  template: Template
  events:
    "click": "click"

  initialize: ->
    @el.width = @dimensions()
    @el.height = @el.width
    @initEvents()
    @render()

  initEvents: ->
    @model.on "change", =>
      @reset()
      @render()

  render: ->
    rasterizeHTML.drawHTML @template(@model.toJSON()), @el
    this

  click: ->
    @saveImg()

  reset: ->
    @el.width = @el.width

  dimensions: ->
    width = @model.get("width")
    height = @model.get("height")
    max = if width > height then width else height
    max * 2

  saveImg: ->
    data = @el.toDataURL("image/png")
    window.location.href = data

module.exports = ImageView
