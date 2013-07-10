class Smorodina.Views.LikeBtn extends Smorodina.Views.Base
  template: JST['like_btn']

  className: 'btn_container_like'
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
    @votable.set sign: 'up', id: '500'
    @result = @votable.destroy()

  create_vote: ->
    @votable.set sign: 'up', id: null
    @result = @votable.save()

