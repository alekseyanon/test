class Smorodina.Views.Chronicle extends Backbone.View
  el: '.chronicle'
  template: JST['chronicle']
  events:
    'click .fetch-results__button a'  : 'add_items'
    'change #chronicleSearchType'     : 'select_type_items'
    'submit .chronicle__search'       : 'select_type_items'

  initialize: ->
    _.bindAll @
    @last_day = 0
    @$content_type = $('#chronicleSearchType')
    @$search_text = $('#chronicleSearchPlace')
    @$fetch_button = $('#searchResultsFetch')
    @$chronicle_elem = $('.backbone_chronicle_content')
    @collection.on('sync', @render, @)
    @collection.fetch()

  render: ->
    @addAll()
    @

  addAll: ->
    @$fetch_button.hide()
    if @collection.length > 0
      ##TODO: remove this sorting and get sorted collection from server
      collection = _.sortBy(@collection.models, (model) -> model.get('created_at'))

      @days_array = _.groupBy(collection, (model) -> model.get('creation_date'))
      dates = _.keys(@days_array)
      first_date = dates[0]
      if @last_day == first_date
        elem = $('.chronicle__section').last()
        elem.append JST['chronicle_day_items'](objects: @days_array[first_date])
        delete @days_array[first_date]
      @$chronicle_elem.append @template(days: @days_array)
      @last_day = _.last(dates)
      unless @collection.end_collection?
        @$fetch_button.show()
    else
      unless @collection.go_offset && @collection.event_offset
        @$chronicle_elem.append JST['chronicle_empty'](place: @$search_text.val(), klass: @$content_type.val())

  add_items: (e) ->
    e.preventDefault()
    @collection.fetch(data:
                        go_offset: @collection.go_offset
                        event_offset: @collection.event_offset
                        type: @$content_type.find(':selected').data('type')
                        text: @$search_text.val())

  select_type_items: (e) ->
    e.preventDefault()
    @last_day = 0
    @$chronicle_elem.html('')
    @collection.fetch(data:
                        go_offset: 0
                        event_offset: 0
                        type: @$content_type.find(':selected').data('type')
                        text: @$search_text.val())



