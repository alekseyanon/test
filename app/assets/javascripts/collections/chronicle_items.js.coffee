#= require models/chronicle_item

class Smorodina.Collections.ChronicleItems extends Backbone.Collection
  model: Smorodina.Models.ChronicleItem
  url: '/api/chronicles/show.json'

  parse: (response)->
    this.offset = response.offset
    response.items
