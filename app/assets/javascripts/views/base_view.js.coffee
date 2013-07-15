class Smorodina.Views.Base extends Backbone.View

  initialize: ->
    _.bindAll @
    _this = @
    @on 'beforeRender', @beforeRender
    @on 'afterRender', @afterRender

    @render = _.wrap(@render, (render)->
      _this.trigger 'beforeRender'
      render()
      _this.trigger 'afterRender'
      return _this
    )

  afterRender: ->

  beforeRender: ->

  show: ->
    @$el.show()

  hide: ->
    @$el.hide()

  is_authorized: ->
    email = $('.slogan-user-panel-container .user-panel').attr 'data-authorized'
    if email != ''
      return true
    else
      @show_login()
      return false

  show_login: ->
    $('#regLoginModal').modal() 
