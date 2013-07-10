class Smorodina.Views.GoBtn extends Smorodina.Views.Base
  template: JST['go_btn']

  className: 'btn_container_go'
  tagName: 'span'
  
  votable: null

  events:
    'click a.button' : 'make_vote' 

  initialize: ->
    _.bindAll @
    @votable = @options.votable
    @votable.on 'change', @render
    @votable.on 'sync', @parse_responce 

  render: ->
    rendered = @template votable: @votable
    @$el.html rendered
    @
    
  parse_responce: ->
    values = $.parseJSON @result.responseText
    data =
      current_user_vote: values.user_vote
      rating: values.positive - values.negative

    @votable.set data

  make_vote: (e) ->
    e.preventDefault()
    if @$('a.button').hasClass 'disbled'
      return

    if @is_authorized()
      if @votable.get('current_user_vote') == 1
        @destroy_vote()
      else
        @create_vote()

  destroy_vote: ->
    @model.set sign: 'up', id: '500'
    @result = @model.destroy()

  create_vote: ->
    @model.set sign: 'down', id: null
    @result = @model.save()

