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
  controlPoints = [
    {
      x: 100
      y: 100
    }
    {
      x: 300
      y: 100
    }
    {
      x: 100
      y: 400
    }
    {
      x: 300
      y: 400
    }
  ]
  # The normalised texture co-ordinates of the quad in the screen image.
  srcPoints = undefined
  # Options for controlling quality.
  qualityOptions = {}

  loadScreenTexture = ->
    if !gl or !glResources
      return
    image = screenImgElement
    extent =
      w: image.naturalWidth
      h: image.naturalHeight
    gl.bindTexture gl.TEXTURE_2D, glResources.screenTexture
    # Scale up the texture to the next highest power of two dimensions.
    canvas = document.createElement('canvas')
    canvas.width = Calc.nextHighestPowerOfTwo(extent.w)
    canvas.height = Calc.nextHighestPowerOfTwo(extent.h)
    ctx = canvas.getContext('2d')
    ctx.drawImage image, 0, 0, image.width, image.height
    gl.texImage2D gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, canvas
    if qualityOptions.linearFiltering
      gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR
      gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR
    else
      gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR
      gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST
    if anisoExt
      # turn the anisotropy knob all the way to 11 (or down to 1 if it is
      # switched off).
      maxAniso = if qualityOptions.anisotropicFiltering then gl.getParameter(anisoExt.MAX_TEXTURE_MAX_ANISOTROPY_EXT) else 1
      gl.texParameterf gl.TEXTURE_2D, anisoExt.TEXTURE_MAX_ANISOTROPY_EXT, maxAniso
    if qualityOptions.mipMapping
      gl.generateMipmap gl.TEXTURE_2D
    gl.bindTexture gl.TEXTURE_2D, null
    # Record normalised height and width.
    w = extent.w / canvas.width
    h = extent.h / canvas.height
    srcPoints = [
      {
        x: 0
        y: 0
      }
      {
        x: w
        y: 0
      }
      {
        x: 0
        y: h
      }
      {
        x: w
        y: h
      }
    ]
    # setup the vertex buffer with the source points
    vertices = []
    i = 0
    while i < srcPoints.length
      vertices.push srcPoints[i].x
      vertices.push srcPoints[i].y
      i++
    gl.bindBuffer gl.ARRAY_BUFFER, glResources.vertexBuffer
    gl.bufferData gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW
    # Redraw the image
    redrawImg()
    return

  redrawImg = ->
    if !gl or !glResources or !srcPoints
      return
    vpW = screenCanvasElement.width
    vpH = screenCanvasElement.height
    # Find where the control points are in 'window coordinates'. I.e.
    # where thecanvas covers [-1,1] x [-1,1]. Note that we have to flip
    # the y-coord.
    dstPoints = []
    i = 0
    while i < controlPoints.length
      dstPoints.push
        x: 2 * controlPoints[i].x / vpW - 1
        y: -(2 * controlPoints[i].y / vpH) + 1
      i++
    # Get the transform
    v = Calc.transformationFromQuadCorners(srcPoints, dstPoints)
    # set background to full transparency
    gl.clearColor 0, 0, 0, 0
    gl.viewport 0, 0, vpW, vpH
    gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT
    gl.useProgram glResources.shaderProgram
    # draw the triangles
    gl.bindBuffer gl.ARRAY_BUFFER, glResources.vertexBuffer
    gl.enableVertexAttribArray glResources.vertAttrib
    gl.vertexAttribPointer glResources.vertAttrib, 2, gl.FLOAT, false, 0, 0

    ###  If 'v' is the vector of transform coefficients, we want to use
        the following matrix:

        [v[0], v[3],   0, v[6]],
        [v[1], v[4],   0, v[7]],
        [   0,    0,   1,    0],
        [v[2], v[5],   0,    1]

        which must be unravelled and sent to uniformMatrix4fv() in *column-major*
        order. Hence the mystical ordering of the array below.
    ###

    gl.uniformMatrix4fv glResources.transMatUniform, false, [
      v[0]
      v[1]
      0
      v[2]
      v[3]
      v[4]
      0
      v[5]
      0
      0
      0
      0
      v[6]
      v[7]
      0
      1
    ]
    gl.activeTexture gl.TEXTURE0
    gl.bindTexture gl.TEXTURE_2D, glResources.screenTexture
    gl.uniform1i glResources.samplerUniform, 0
    gl.drawArrays gl.TRIANGLE_STRIP, 0, 4

  setupControlHandles = (controlHandlesElement, onChangeCallback) ->
    # Use d3.js to provide user-draggable control points
    rectDragBehav = d3.behavior.drag().on('drag', (d, i) ->
      d.x += d3.event.dx
      d.y += d3.event.dy
      d3.select(this).attr('cx', d.x).attr 'cy', d.y
      onChangeCallback()
      return
    )
    dragT = d3.select(controlHandlesElement).selectAll('circle').data(controlPoints).enter().append('circle').attr('cx', (d) ->
      d.x
    ).attr('cy', (d) ->
      d.y
    ).attr('r', 30).attr('class', 'control-point').call(rectDragBehav)
    return

  saveResult = ->
    resultCanvas = document.createElement('canvas')
    resultCanvas.width = screenCanvasElement.width
    resultCanvas.height = screenCanvasElement.height
    ctx = resultCanvas.getContext('2d')
    bgImage = new Image
    bgImage.crossOrigin = ''

    bgImage.onload = ->
      ctx.drawImage screenCanvasElement, 0, 0
      data = resultCanvas.toDataURL("image/png")
      window.location.href = data

    bgImage.src = document.getElementById('background').src

  loadScreenTexture()
  # UI for saving image
  document.getElementById('saveResult').onclick = saveResult
  # Reflect any changes in quality options
  # Wire in the control handles to dragging. Call 'redrawImg' when they change.
  controlHandlesElement = document.getElementById('controlHandles')
  setupControlHandles controlHandlesElement, redrawImg
  # Wire up the control handle toggle
  drawControlPointsElement = document.getElementById('drawControlPoints')

  drawControlPointsElement.onchange = ->
    controlHandlesElement.style.visibility = if ! !drawControlPointsElement.checked then 'visible' else 'hidden'

  # Create a WegGL context from the canvas which will have the screen image
  # rendered to it. NB: preserveDrawingBuffer is needed for rendering the
  # image for download. (Otherwise, the canvas appears to have nothing in
  # it.)
  screenCanvasElement = document.getElementById('screenCanvas')
  glOpts =
    antialias: true
    depth: false
    preserveDrawingBuffer: true
  gl = screenCanvasElement.getContext('webgl', glOpts) or screenCanvasElement.getContext('experimental-webgl', glOpts)
  # See if we have the anisotropic filtering extension by trying to get
  # if from the WebGL implementation.
  anisoExt = gl.getExtension('EXT_texture_filter_anisotropic') or gl.getExtension('MOZ_EXT_texture_filter_anisotropic') or gl.getExtension('WEBKIT_EXT_texture_filter_anisotropic')
  # Setup the GL context compiling the shader programs and returning the
  # attribute and uniform locations.
  glResources = WebGL.setupGlContext(gl)
  # This object will store the width and height of the screen image in
  # normalised texture co-ordinates in its 'w' and 'h' fields.
  screenTextureSize = undefined
  # The only readon this element exists in the DOM is too (potentially)
  # cache the image for us before this script is run and to specity
  # the screen image URL in a more obvious place.
  imgElement = document.getElementById('screen')
  imgElement.style.display = 'none'
  # Create an element to hold the screen image and arracnge for loadScreenTexture
  # to be called when the image is loaded.
  screenImgElement = new Image
  screenImgElement.crossOrigin = ''
  screenImgElement.onload = loadScreenTexture
  screenImgElement.src = imgElement.src
