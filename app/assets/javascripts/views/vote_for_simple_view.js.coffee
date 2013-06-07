class Smorodina.Views.VoteForSimple extends Smorodina.Views.Base
  template: ''

  className: 'simple_voting'
  
  votable: null

  path: ''

  events:
    'submit form' : 'make_vote' 

  initialize: ->
    _.bindAll @
    @votable = @options.votable
    @options.template ||= 'vote_for_simple'
    @template = JST[@options.template]
    @votable.on 'change', @render

    @path = @votable.get('rating').vote_url
    @model = new Backbone.Model [], {url: @path, id: null, sign: ''}
    @model.on 'sync', @parse_responce 

  render: ->
    rendered = @template rating: @votable.get('rating')
    @$el.html rendered
    @
    
  parse_responce: ->
    values = $.parseJSON @result.responseText
    rating =
      vote_url: @path
      current_user_vote: values.user_vote
      votes_for: values.positive
      votes_against: values.negative
    @votable.set rating: rating

  make_vote: (e) ->
    e.preventDefault()

    if !@is_authorized()
      @show_login()
      return

    user_vote = @votable.get('rating').current_user_vote
    @direction = $(e.currentTarget).find('input[name="sign"]').attr 'value'

    switch user_vote
      when 1
        if @direction == 'up'
          @destroy_vote()

        if @direction == 'down'
          @create_vote()

      when -1
        if @direction == 'up'
          @create_vote()

        if @direction == 'down'
          @destroy_vote()

      when 0
        @create_vote()

  destroy_vote: ->
    @model.set sign: @direction, id: '500'
    @result = @model.destroy()

  create_vote: ->
    @model.set sign: @direction, id: null
    @result = @model.save()

