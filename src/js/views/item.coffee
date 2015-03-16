_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Template = require "../templates/item.hbs"

WebGL = require "../utils/webgl"
Calc = require "../utils/calc"

class ItemView extends Backbone.View
  MIN_SIZE: 300
  tagName: "article"
  template: Template
  #events:
    #"click": "click"

  onRender: ->
    @$canvas = @$("canvas")
    @canvas = @$canvas[0]
    glOpts =
      antialias: true
      depth: false
      preserveDrawingBuffer: true
    @gl = @canvas.getContext("webgl", glOpts) or @canvas.getContext("experimental-webgl", glOpts)
    @anisoExt = @gl.getExtension("EXT_texture_filter_anisotropic") or @gl.getExtension("WEBKIT_EXT_texture_filter_anisotropic")
    @glResources = WebGL.setupGlContext(@gl)
    @image = new Image()
    @image.crossOrigin = ""
    @image.onload = =>
      @loadScreenTexture()
    @image.src = "http://i.imgur.com/vsZypFu.png"

  loadScreenTexture: ->
    WebGL.screenSetup(@image, @anisoExt, @gl, @glResources, (srcPoints) => @redrawImg(srcPoints))

  redrawImg: (srcPoints) ->
    vpW = @canvas.width
    vpH = @canvas.height
    dstPoints =
      [
        { x: -0.859999984741211, y: 0.7514792899408285 }
        { x: 0.9159999999999999, y: 0.7199211045364892 }
        { x: -0.7879999847412109, y: -0.8303747534516766}
        { x: 0.23199999999999998, y: -0.5857988165680474 }
      ]
    v = Calc.transformationFromQuadCorners(srcPoints, dstPoints)
    WebGL.draw(v, vpW, vpH, @gl, @glResources)

  render: ->
    @$el.html(@template)
    @onRender()
    @

module.exports = ItemView
