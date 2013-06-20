#= require ../collections/geo_objects
#= require ./base_view

class Smorodina.Views.PageTitle extends Smorodina.Views.Base
  el: '#pageTitle'

  initialize: ->
    super()
    @defaultTitle = @$el.data 'defaultTitle'
    @collection.on 'request', @onRequest
    @collection.on 'reset', @render

  onRequest: (collection, xhr, options) ->
    console.log options
    @title = options.query.text;

  render: ->
    title = if @collection.length and @title then @title else @defaultTitle
    @$el.html title
