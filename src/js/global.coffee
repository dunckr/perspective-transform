$ = require "jquery"

$ ->
  canvas = $("canvas")[0]

  img = new Image()
  img.src = "images/example.jpg"

  img.onload = ->

    canvas.width = img.width
    canvas.height = img.height

    ctx = canvas.getContext("2d")

    #ctx.transform(1, -0.08, 0, 1, 0, 50)
    #ctx.transform(1,0.5,-0.5,1,30,10)

    #ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, canvas.width, canvas.height)
    #ctx.drawImage(img, 0, 0, 100, 100 * img.height / img.width)
    #ctx.drawImage(img, 0, 0)
    drawImageScaled(img, ctx)

    #data = canvas.toDataURL("image/png")
    #window.location.href = data

drawImageScaled = (img, ctx) ->
  canvas = ctx.canvas
  hRatio = canvas.width / img.width
  vRatio = canvas.height / img.height
  ratio = Math.min(hRatio, vRatio)
  centerShift_x = (canvas.width - img.width * ratio) / 2
  centerShift_y = (canvas.height - img.height * ratio) / 2
  ctx.clearRect 0, 0, canvas.width, canvas.height
  ctx.drawImage img, 0, 0, img.width, img.height, centerShift_x, centerShift_y, img.width * ratio, img.height * ratio
