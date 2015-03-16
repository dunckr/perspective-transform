_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Items = require "./collections/items"
ListView = require "./views/list"

Item = require "./models/item"
numeric = require "./vendor/numeric"

d3 = require "d3"
WebGL = require "./utils/webgl"
Calc = require "./utils/calc"

$ ->
  srcPoints = undefined

  loadScreenTexture = ->
    WebGL.screenSetup(screenImgElement, anisoExt, gl, glResources, redrawImg)

  redrawImg = (srcPoints) ->
    srcPoints = srcPoints
    vpW = screenCanvasElement.width
    vpH = screenCanvasElement.height
    dstPoints =
      [
        { x: -0.859999984741211, y: 0.7514792899408285 }
        { x: 0.9159999999999999, y: 0.7199211045364892 }
        { x: -0.7879999847412109, y: -0.8303747534516766}
        { x: 0.23199999999999998, y: -0.5857988165680474 }
      ]
    v = Calc.transformationFromQuadCorners(srcPoints, dstPoints)
    WebGL.draw(v, vpW, vpH, gl, glResources)

  saveResult = ->
    resultCanvas = document.createElement('canvas')
    resultCanvas.width = screenCanvasElement.width
    resultCanvas.height = screenCanvasElement.height
    ctx = resultCanvas.getContext('2d')
    bgImage = new Image()

    bgImage.onload = ->
      ctx.drawImage screenCanvasElement, 0, 0
      data = resultCanvas.toDataURL("image/png")
      window.location.href = data
    bgImage.src = document.getElementById('background').src

  loadScreenTexture()
  document.getElementById('saveResult').onclick = saveResult

  screenCanvasElement = document.getElementById('screenCanvas')
  glOpts =
    antialias: true
    depth: false
    preserveDrawingBuffer: true
  gl = screenCanvasElement.getContext('webgl', glOpts) or screenCanvasElement.getContext('experimental-webgl', glOpts)
  anisoExt = gl.getExtension('EXT_texture_filter_anisotropic') or gl.getExtension('MOZ_EXT_texture_filter_anisotropic') or gl.getExtension('WEBKIT_EXT_texture_filter_anisotropic')
  glResources = WebGL.setupGlContext(gl)
  screenTextureSize = undefined
  imgElement = document.getElementById('screen')
  imgElement.style.display = 'none'
  screenImgElement = new Image
  screenImgElement.crossOrigin = ''
  screenImgElement.onload = loadScreenTexture
  screenImgElement.src = imgElement.src
