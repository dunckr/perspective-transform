$ = require "jquery"
Items = require "./collections/items"
ListView = require "./views/list"

Item = require "./models/item"

$ ->
  items = new Items()
  item1 = new Item()
  item2 = new Item()
  items.add([item1, item2])
  new ListView(collection: items).render()
