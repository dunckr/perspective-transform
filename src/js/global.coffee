_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Items = require "./collections/items"
ListView = require "./views/list"

Item = require "./models/item"

$ ->
  items = new Items()
  data = [
    [1, -0.08, 0, 1, 0, 50]
    [1, -0.08, 0, 1, 0, 50]
  ]
  for matrix in data
    item = new Item(matrix: matrix)
    items.add(item)
  new ListView(collection: items).render()
