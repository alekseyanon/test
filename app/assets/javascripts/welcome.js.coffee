if document.location.pathname is "/"
  $ ->
    $('#mainSearchFieldInput').on 'focus', ->
      $('.how-to-search').addClass 'how-to-search_hidden'

    $('.control-panel__info-button').on('click', ->).popover
      html: true
      placement: 'bottom'
      trigger: 'click'
      content: ->
        $('.control-panel__info-section').html()