#= require models/chronicle_item

class Smorodina.Collections.ChronicleItems extends Backbone.Collection
  model: Smorodina.Models.ChronicleItem
  url: '/api/chronicles/show.json'

  parse: (response)->
    @go_offset = response.go_offset
    @event_offset = response.event_offset
    response.items
