$ = require "jquery"

$ ->
  console.log "we are ready.."

  canvas = $("canvas")[0]

  img = new Image()
  img.src = "images/gulp.png"

  img.onload = ->

    ctx = canvas.getContext("2d")

    ctx.transform(1, -0.08, 0, 1, 0, 50)
    #ctx.transform(1,0.5,-0.5,1,30,10)

    ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, canvas.width, canvas.height)
    #ctx.drawImage(img, 0, 0)
    #
    data = canvas.toDataURL("image/png")
    window.location.href = data
