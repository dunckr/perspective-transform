_ = require "underscore"
Backbone = require "backbone"
Item = require "../models/item"

class Items extends Backbone.Collection

  model: Item

module.exports = Items
