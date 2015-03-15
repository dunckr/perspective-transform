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


