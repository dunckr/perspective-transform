_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Template = require "../templates/item.hbs"
WebGL = require "../utils/webgl"
Calc = require "../utils/calc"

class ItemView extends Backbone.View
  glOpts:
    antialias: true
    depth: false
    preserveDrawingBuffer: true
  tagName: "article"
  template: Template
  events:
    "click": "click"

  onRender: ->
    @$canvas = @$("canvas")
    @canvas = @$canvas[0]
    @gl = @canvas.getContext("webgl", @glOpts) or @canvas.getContext("experimental-webgl", @glOpts)
    @anisoExt = @gl.getExtension("EXT_texture_filter_anisotropic") or @gl.getExtension("WEBKIT_EXT_texture_filter_anisotropic")
    @glResources = WebGL.setupGlContext(@gl)
    @image = new Image()
    @image.crossOrigin = ""
    @image.onload = => @loadScreenTexture()
    @image.src = @model.get("image")

  loadScreenTexture: ->
    WebGL.screenSetup(@image, @anisoExt, @gl, @glResources, (srcPoints) => @redrawImg(srcPoints))

  redrawImg: (srcPoints) ->
    @srcPoints = srcPoints
    vpW = @canvas.width
    vpH = @canvas.height
    v = Calc.transformationFromQuadCorners(srcPoints, @model.get("points"))
    WebGL.draw(v, vpW, vpH, @gl, @glResources)

  click: ->
    @canvas.width = @image.width * 2
    @canvas.height = @image.height * 2
    @redrawImg(@srcPoints)
    @saveImg()

  saveImg: ->
    data = @canvas.toDataURL("image/png")
    window.location.href = data

  render: ->
    @$el.html(@template)
    @onRender()
    @

module.exports = ItemView
