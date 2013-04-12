#= require ../collections/events
#= require ./base_view

class Smorodina.Views.EventSearchForm extends Smorodina.Views.Base
  el: '#eventSearchForm'
  events:
    'submit': 'onSubmit'
    'click .search-panel__header__back-link': 'return'

  initialize: ->
    super()
    @$title = @$ '.search-panel__header'
    @$titleText = @$title.find '.search-panel__header__text'
    @defaultTitle = @$title.data 'default'

    @$dateText= @$ '.search-panel__change-date__text'
    @$dateInput= @$ '.search-panel__change-date__input'

    @collection.on 'request', @onRequest
    @collection.on 'reset', @render
    Backbone.on 'eventsPageLoad', @onPageLoad

  onRequest: (collection, xhr, options) ->
    @title = options.query.text

  onSubmit: (e) ->
    Backbone.trigger 'eventSearchFormSubmit'
    Backbone.history.navigate('search', true)
    @collection.fetch({ data: @$el.serializeObject() })
    e.preventDefault()

  changeTitle: ->
    unless @title
      @$title.addClass('search-panel__header_default')
      @$titleText.html(@defaultTitle)
    else
      @$title.removeClass('search-panel__header_default')
      @$titleText.html @title || @defaulTitle

    @title = ''

  render: ->
    @changeTitle()

  return: (e) ->
    Backbone.history.navigate('', true)
    e.preventDefault()
