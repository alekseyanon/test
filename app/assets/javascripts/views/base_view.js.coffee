class Smorodina.Views.Base extends Backbone.View
  initialize: ->
    _.bindAll(@)

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
