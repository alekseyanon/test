#= require ./routers/event_router
#= require collections/events

Smorodina.Pages.Events = ->
  events = new Smorodina.Collections.Events

  $ ->
    Smorodina.Utils.History.stop()
    new Smorodina.Routers.EventRouter
    new Smorodina.Views.EventSearchForm(collection:events)
    new Smorodina.Views.EventList(collection:events)
    new Smorodina.Views.SearchFetch(collection:events)
    new Smorodina.Views.SearchResultsPanel(collection:events)
    new Smorodina.Views.SearchEmpty(collection:events)

    Backbone.history.start(pushState: true, root: '/events')

    initEventAutoComplete = ->
      $('#eventSearchFormInput').autocomplete
        source: '/api/events/autocomplete'
        minChars: 2
        select: (event, ui) ->
          event.preventDefault()
          $('#eventSearchFormInput').val(ui.item.label)

    initDatePicker = ->
      $.extend $.fn.pickadate.defaults, 
        monthsFull: [ 'Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря' ],
        monthsShort: [ 'Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек' ],
        weekdaysFull: [ 'воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота' ],
        weekdaysShort: [ 'вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб' ],
        today: 'сегодня',
        clear: 'удалить',
        firstDay: 1,
        format: 'd mmmm yyyy г.',
        formatSubmit: 'yyyy/mm/dd'

      picker = $('#triggerDatePicker').pickadate().pickadate('picker')
      picker.on 'close', ->
        date = picker.get('select', 'yyyy/mm/dd').replace(/\//g, '-')
        $('#event-date').text date
        $('#date-input').val date

    initEventAutoComplete()
    initDatePicker()
