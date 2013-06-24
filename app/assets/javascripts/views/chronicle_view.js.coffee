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
    @$content_type = ''
    @$search_text = ''
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
      @days = _.groupBy @collection.models, (model) ->
        model.get('creation_date')
      dates = _.keys(@days)
      first_date = dates[0]
      if @last_day == first_date
        elem = $('.chronicle__section').last()
        elem.append JST['chronicle_day_items'](objects: @days[first_date])
        delete @days[first_date]
      @$chronicle_elem.append @template(days: @days)
      @last_day = _.last(dates)
      unless @collection.end_collection?
        @$fetch_button.show()
    else
      unless @collection.go_offset && @collection.event_offset
        @$content_type = $('#chronicleSearchType').val()
        @$search_text = $('#chronicleSearchPlace').val()
        @$chronicle_elem.append JST['chronicle_empty'](place: @$search_text, klass: @$content_type)

  add_items: (e) ->
    e.preventDefault()
    @collection.fetch(data:
                        go_offset: @collection.go_offset
                        event_offset: @collection.event_offset
                        type: @$content_type
                        text: @$search_text)

  select_type_items: (e) ->
    e.preventDefault()
    @$content_type = $('#chronicleSearchType :selected').data('type')
    @$search_text = $('#chronicleSearchPlace').val()
    @$chronicle_elem.html('')
    @collection.fetch(data:
                        go_offset: 0
                        event_offset: 0
                        type: @$content_type
                        text: @$search_text)



