class Smorodina.Views.LikeBtn extends Smorodina.Views.Base
  template: JST['like_btn']

  className: 'btn_container_like'
  tagName: 'span'
  
  votable: null

  events:
    'click a.button' : 'make_vote' 

  initialize: ->
    _.bindAll @
    @model.on 'change', @render
    @model.on 'sync', @parse_response 
    @render()

  render: ->
    @$el.html @template(votable: @model)
    @
    
  parse_response: (model, response)->
    data =
      current_user_vote: response.user_vote
      rating: response.positive - response.negative

    @model.set data

  make_vote: (e) ->
    e.preventDefault()
    if @$('a.button').hasClass 'disabled'
      return

    if @is_authorized()
      if @model.get('current_user_vote') == 1
        @destroy_vote()
      else
        @create_vote()

  destroy_vote: ->
    @model.set sign: 'up', id: '500'
    @model.destroy()

  create_vote: ->
    @model.set sign: 'up', id: null
    @model.save()

