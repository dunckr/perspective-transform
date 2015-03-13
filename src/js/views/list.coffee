_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
ItemView = require "./item"
Template = require "../templates/list.hbs"

class ListView extends Backbone.View

  el: "#list"
  template: Template

  render: ->
    @$el.html(@template)
    @collection.forEach (model) =>
      view = new ItemView(model: model)
      @$("section").append(view.render().$el)
    @

module.exports = ListView
