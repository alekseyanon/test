#= require ../collections/landmarks
#= require ././base_view

class Smorodina.Views.PageTitle extends Smorodina.Views.Base
  el: '#pageTitle'

  init: ->
    @defaultTitle = @$el.data 'defaultTitle'
    @collection.on 'request', @onRequest
    @collection.on 'reset', @render

  onRequest: (collection, xhr, options) ->
    @title = options.query.text;

  render: ->
    title = if @collection.length and @title then @title else @defaultTitle
    @$el.html title