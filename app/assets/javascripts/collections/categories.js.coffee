#= require models/category

class Smorodina.Collections.Categories extends Backbone.Collection
  model: Smorodina.Models.Category
  url: '/api/categories/index'
  initialize: ->
    @on 'request', @onRequest
    @on 'reset', @onReset

  onRequest: ->
    #console.log arguments

  onReset: ->
    #console.log arguments
