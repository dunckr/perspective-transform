_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Items = require "./collections/items"
ListView = require "./views/list"

Item = require "./models/item"

$ ->
  items = new Items()
  item1 = new Item()
  item2 = new Item()
  item3 = new Item()
  item4 = new Item()
  item5 = new Item()
  item6 = new Item()
  items.add([item1, item2, item3, item4, item5, item6])
  new ListView(collection: items).render()
