$ = require "jquery"

$ ->
  $canvas = $("canvas")

  for el in $canvas
    loadImageOntoCanvas(el)

loadImageOntoCanvas = (el) ->
  $el = $(el)
  canvas = el
  img = new Image()
  img.src = "images/example.jpg"
  img.onload = ->
    $el.click -> onClick(canvas, img)
    canvas.width = 100
    canvas.height = 100
    ctx = canvas.getContext("2d")
    ctx.transform(1, -0.08, 0, 1, 0, 50)
    ctx.drawImage(img, 0, 0)

onClick = (canvas, img) ->
  OFFSET = 1.2
  canvas.width = img.width * OFFSET
  canvas.height = img.height * OFFSET
  ctx = canvas.getContext("2d")
  ctx.transform(1, -0.08, 0, 1, 0, 50)
  ctx.drawImage(img, (canvas.width-img.width)/2, (canvas.height-img.height)/2)
  saveImg(canvas)

saveImg = (canvas) ->
  data = canvas.toDataURL("image/png")
  window.location.href = data
