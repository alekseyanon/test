class Smorodina.Views.Base extends Backbone.View
  initialize: ->
    _.bindAll(@)

  show: ->
    @$el.show()

  hide: ->
    @$el.hide()

  is_authorized: ->
    email = $('.slogan-user-panel-container .user-panel').attr 'data-authorized'
    !!email

  show_login: ->
    $('#regLoginModal').modal() 
