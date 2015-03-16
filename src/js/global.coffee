_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Items = require "./collections/items"
ListView = require "./views/list"

Item = require "./models/item"

$ ->
  item = new Item()
  items = new Items()
  items.add(item)

  listView = new ListView(collection: items).render()
