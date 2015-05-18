$ = require "jquery"
dat = require "dat-gui"

class ControlsView

  constructor: (options) ->
    @model = options.model
    @gui = new dat.GUI()
    @initEvents()
    @render()

  initEvents: ->
    $("#imageLoader").change (e) => @uploadImage(e)

  render: ->
    buttons =
      save: ->
        # fix use events
        $("#canvas").click()
      reset: => @model.set(@model.defaults)
      upload: => $("#imageLoader").click()
    @gui.add(buttons, "upload")
    @gui.add(buttons, "reset")

    settingsFolder = @gui.addFolder("settings")
    @factory(settingsFolder, "perspective", 0, 1000)
    @factory(settingsFolder, "rotateX", 0, 360)
    @factory(settingsFolder, "rotateY", 0, 360)
    @factory(settingsFolder, "rotateZ", 0, 360)
    settingsFolder.open()

    paddingFolder = @gui.addFolder("padding")
    @factory(paddingFolder, "paddingTop", 0, 100)
    @factory(paddingFolder, "paddingRight", 0, 100)
    @factory(paddingFolder, "paddingBottom", 0, 100)
    @factory(paddingFolder, "paddingLeft", 0, 100)
    paddingFolder.open()

    @gui.add(buttons, "save")

  factory: (folder, key, min, max) ->
    attrs = @model.toJSON()
    folder
      .add(attrs, key, min, max)
      .onFinishChange (value) => @updated(key, value)

  updated: (key, value)->
    @model.set(key, value)

  uploadImage: (e) ->
    reader = new FileReader()
    reader.onload = (e) =>
      console.log "reader laoded"
      img = new Image()
      img.onload = =>
        @model.set("file", img.src)
      img.src = e.target.result
    reader.readAsDataURL(e.target.files[0])


module.exports = ControlsView
