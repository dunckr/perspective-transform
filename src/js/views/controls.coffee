$ = require "jquery"
dat = require "dat-gui"

class ControlsView

  constructor: (options) ->
    @model = options.model
    @gui = new dat.GUI()
    @render()

  render: ->
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

    buttons =
      save: ->
        # fix use events
        $("#canvas").click()
      reset: =>
        @model.set(@model.defaults)
    @gui.add(buttons, "save")
    @gui.add(buttons, "reset")

  factory: (folder, key, min, max) ->
    attrs = @model.toJSON()
    folder
      .add(attrs, key, min, max)
      .onFinishChange (value) => @updated(key, value)

  updated: (key, value)->
    @model.set(key, value)

module.exports = ControlsView
