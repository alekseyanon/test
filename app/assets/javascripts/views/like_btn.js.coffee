class Smorodina.Views.LikeBtn extends Smorodina.Views.Base
  template: JST['like_btn']

  className: 'btn_container_like'
  
  events:
    'click a.button' : 'make_vote' 

  initialize: ->
    _.bindAll @
    @model.on 'change', @render
    @render()

  render: ->
    @$el.html @template(votable: @model)
    @
    
  make_vote: (e) ->
    e.preventDefault()
    if @$('a.button').hasClass 'disabled'
      return

    if @is_authorized()
      if @model.get('current_user_vote') == 1
        @model.destroy_vote('up')
      else
        @model.create_vote('up')
