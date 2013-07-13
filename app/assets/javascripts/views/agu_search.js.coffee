#= require ./base_view

class Smorodina.Views.AguSearch extends Smorodina.Views.Base
  url: '/api/agus/search_autocomplete.json'

  initialize: ->
    super()
    @render()

    @data = {}

    @$input = @$ 'input.agu-search__input'
    @$input
      .autocomplete
        html: true
        source: @findAgus
        autoFocus: true
        select: @_commitSelect
    @$input.on 'keydown', (e) =>
      if e.which == 13
        @_commitSelect()
    @$('.agu-search__button').click =>
      @_commitSelect()

  _commitSelect: ->
    $item = @$('.ui-autocomplete .ui-menu-item a.ui-state-focus')
    if not $item.length
      $item = @$('.ui-autocomplete .ui-menu-item:first a')
    if not $item.length
      return
    @$input.val $item.text()
    @_aguSelected()

  _htmlTitle: (title, query) ->
    title.replace new RegExp($.ui.autocomplete.escapeRegex(query), 'g'), "<strong>#{query}</strong>"

  findAgus: (request, cb) ->
    $.ajax
      dataType: "json"
      url: @url
      data: { query: request.term }
      error: =>
        @data = {}
        cb []
      success: (data) =>
        @data = {}
        for d in data
          d.map_bounds = (x.reverse() for x in d.map_bounds)
          @data[d.title] = d
        cb (d.htmlTitle or @_htmlTitle(d.title, request.term) for d in data)

  _aguSelected: ->
    val = @val()
    data = @data[val]
    @trigger 'selected',
      title: val
      map_bounds: data?.map_bounds

  val: ->
    @$input.val()

  render: ->
    @
