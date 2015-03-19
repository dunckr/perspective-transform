_ = require "underscore"
Backbone = require "backbone"
Backbone.$ = $ = require "jquery"
Items = require "./collections/items"
ListView = require "./views/list"

Item = require "./models/item"

$ ->
  items = new Items()
  data = []

  #]
  #[
    #{ x: -0.268, y: 0.960552268244576 }
    #{ x: 0.3999999999999999, y: 0.6962524654832347 }
    #{ x: -0.96, y: -0.10059171597633143  }
    #{ x: -0.26, y: -0.47928994082840237 }
  #]
  #tl = { x: -0.268, y: 0.960552268244576 }
  #tr = { x: 0.3999999999999999, y: 0.6962524654832347 }
  #width = 0.6
  #height = 0.8

  #item =
  #[
    #tl
    #tr
    #{ x: tl.x - width, y: tl.y - height }
    #{ x: tr.x - width, y: tr.y - height }
  #]
  #data.push(item)
  #[
    #{ x: -0.18400000000000005, y: -0.1637080867850098  }
    #{ x: 0.45999999999999996, y: 0.1952662721893491 }
  #]
  #tl = { x: -0.9359999999999999, y: 0.6883629191321499 }
  #tr = { x: -0.344, y: 0.9723865877712031 }
  #width = 1.1
  #height = 0.8

  #item =
  #[
    #tl
    #tr
    #{ x: tl.x - width, y: tl.y - height }
    #{ x: tr.x - width, y: tr.y - height }
  #]
  #data.push(item)

  tl = { x: -0.32799999999999996, y: 1.0039447731755424 }
  tr = { x: 0.3919999999999999, y: 0.7159763313609467 }
  width = 0.5
  height = 1

  item =
  [
    tl
    tr
    { x: tl.x - width, y: tl.y - height }
    { x: tr.x - width, y: tr.y - height }
  ]
  data.push(item)


  tl = { x: -0.912, y: 0.6765285996055227 }
  tr = { x: -0.16000000000000003, y: 0.9960552268244576 }
  width = 0.5
  height = 1

  item =
  [
    tl
    tr
    { x: tl.x + width, y: tl.y - height }
    { x: tr.x + width, y: tr.y - height }
  ]
  data.push(item)

  tl = { x: -0.20799999999999996, y: 1.0039447731755424 }
  tr = { x: 0.5119999999999999, y: 0.7159763313609467 }
  width = 0.8
  height = 0.9

  item =
  [
    tl
    tr
    { x: tl.x - width, y: tl.y - height }
    { x: tr.x - width, y: tr.y - height }
  ]
  data.push(item)

  tl = { x: -0.912, y: 0.6765285996055227 }
  tr = { x: -0.16000000000000003, y: 0.9960552268244576 }
  width = 0.8
  height = 0.9

  item =
  [
    tl
    tr
    { x: tl.x + width, y: tl.y - height }
    { x: tr.x + width, y: tr.y - height }
  ]
  data.push(item)


  tl = { x: -0.959999984741211, y: 0.7514792899408285 }
  tr = { x: 0.8159999999999999, y: 0.7199211045364892 }
  width = 0.1
  height = 1.1

  item =
  [
    tl
    tr
    { x: tl.x + width, y: tl.y - height }
    { x: tr.x + width, y: tr.y - height }
  ]
  data.push(item)

  tl = { x: -0.859999984741211, y: 0.7514792899408285 }
  tr = { x: 0.9159999999999999, y: 0.7199211045364892 }
  width = 0.1
  height = 1.1

  item =
  [
    tl
    tr
    { x: tl.x - width, y: tl.y - height }
    { x: tr.x - width, y: tr.y - height }
  ]
  data.push(item)
  #tl = { x: -0.9359999999999999, y: 0.6883629191321499 }
  #tr = { x: -0.344, y: 0.9723865877712031 }
  #width = 0.2
  #height = 0.3

  #item =
  #[
    #tl
    #tr
    #{ x: tl.x + width, y: tl.y - height }
    #{ x: tr.x + width, y: tr.y - height }
  #]
  #data.push(item)
  for item in data
    item = new Item(points: item)
    items.add(item)

  listView = new ListView(collection: items).render()
