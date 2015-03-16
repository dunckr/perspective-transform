_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Items = require "./collections/items"
ListView = require "./views/list"

Item = require "./models/item"

$ ->
  items = new Items()
  data =
  [
    [
      { x: -0.859999984741211, y: 0.7514792899408285 }
      { x: 0.9159999999999999, y: 0.7199211045364892 }
      { x: -0.7879999847412109, y: -0.8303747534516766}
      { x: 0.23199999999999998, y: -0.5857988165680474 }
    ]
  ]
  for item in data
    item = new Item(points: item)
    items.add(item)

  listView = new ListView(collection: items).render()
