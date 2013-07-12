class Smorodina.Views.VoteForSimple extends Smorodina.Views.Base
  events:
    'submit form' : 'make_vote' 

  initialize: ->
    _.bindAll @
    @options.template ||= 'vote_for_simple'
    @template = JST[@options.template]

    @model.on 'sync', @parse_response 
    @model.on 'change', @render
    @render()

  render: ->
    @$el.html @template(rating: @model)
    @$('.tooltip_init').tooltip()
    @
    
  parse_response: (model, response)->
    rating =
      current_user_vote: response.user_vote
      votes_for: response.positive
      votes_against: response.negative

    @model.set rating

  make_vote: (e) ->
    e.preventDefault()

    if @is_authorized()
      user_vote = @model.get 'current_user_vote'
      @direction = $(e.currentTarget).find('input[name="sign"]').attr 'value'

      switch user_vote
        when 1
          if @direction == 'up'
            @destroy_vote()
          else
            @create_vote()

        when -1
          if @direction == 'up'
            @create_vote()
          else
            @destroy_vote()

        when 0
          @create_vote()

  destroy_vote: ->
    @model.set sign: @direction, id: '500'
    @model.destroy()

  create_vote: ->
    @model.set sign: @direction, id: null
    @model.save()

