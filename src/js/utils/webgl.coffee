Calc = require "./calc"

module.exports =
  setupGlContext: (gl) ->
    # Store return values here
    rv = {}
    # Vertex shader:
    vertShaderSource = [
      'attribute vec2 aVertCoord;'
      'uniform mat4 uTransformMatrix;'
      'varying vec2 vTextureCoord;'
      'void main(void) {'
      '    vTextureCoord = aVertCoord;'
      '    gl_Position = uTransformMatrix * vec4(aVertCoord, 0.0, 1.0);'
      '}'
    ].join('\n')
    vertexShader = gl.createShader(gl.VERTEX_SHADER)
    gl.shaderSource vertexShader, vertShaderSource
    gl.compileShader vertexShader
    if !gl.getShaderParameter(vertexShader, gl.COMPILE_STATUS)
      addError 'Failed to compile vertex shader:' + gl.getShaderInfoLog(vertexShader)
    # Fragment shader:
    fragShaderSource = [
      'precision mediump float;'
      'varying vec2 vTextureCoord;'
      'uniform sampler2D uSampler;'
      'void main(void)  {'
      '    gl_FragColor = texture2D(uSampler, vTextureCoord);'
      '}'
    ].join('\n')
    fragmentShader = gl.createShader(gl.FRAGMENT_SHADER)
    gl.shaderSource fragmentShader, fragShaderSource
    gl.compileShader fragmentShader
    if !gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)
      addError 'Failed to compile fragment shader:' + gl.getShaderInfoLog(fragmentShader)
    # Compile the program
    rv.shaderProgram = gl.createProgram()
    gl.attachShader rv.shaderProgram, vertexShader
    gl.attachShader rv.shaderProgram, fragmentShader
    gl.linkProgram rv.shaderProgram
    if !gl.getProgramParameter(rv.shaderProgram, gl.LINK_STATUS)
      addError 'Shader linking failed.'
    # Create a buffer to hold the vertices
    rv.vertexBuffer = gl.createBuffer()
    # Find and set up the uniforms and attributes
    gl.useProgram rv.shaderProgram
    rv.vertAttrib = gl.getAttribLocation(rv.shaderProgram, 'aVertCoord')
    rv.transMatUniform = gl.getUniformLocation(rv.shaderProgram, 'uTransformMatrix')
    rv.samplerUniform = gl.getUniformLocation(rv.shaderProgram, 'uSampler')
    # Create a texture to use for the screen image
    rv.screenTexture = gl.createTexture()
    rv

  draw: (v, vpW, vpH, gl, glResources) ->
    gl.clearColor 0, 0, 0, 0
    gl.viewport 0, 0, vpW, vpH
    gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT
    gl.useProgram glResources.shaderProgram
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

  screenSetup: (image, anisoExt, gl, glResources, cb) ->
    if !gl or !glResources
      return
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
    gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR
    gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR
    if anisoExt
      # turn the anisotropy knob all the way to 11 (or down to 1 if it is
      # switched off).
      maxAniso = gl.getParameter(anisoExt.MAX_TEXTURE_MAX_ANISOTROPY_EXT)
      gl.texParameterf gl.TEXTURE_2D, anisoExt.TEXTURE_MAX_ANISOTROPY_EXT, maxAniso
    gl.generateMipmap gl.TEXTURE_2D
    gl.bindTexture gl.TEXTURE_2D, null
    # Record normalised height and width.
    w = extent.w / canvas.width
    h = extent.h / canvas.height
    srcPoints = [
      { x: 0, y: 0 }
      { x: w, y: 0 }
      { x: 0, y: h }
      { x: w, y: h }
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
    if !gl or !glResources or !srcPoints
      return
    else
      cb(srcPoints)
