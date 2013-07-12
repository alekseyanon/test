class Smorodina.Views.VoteForSimple extends Smorodina.Views.Base
  events:
    'submit form' : 'make_vote' 

  initialize: ->
    _.bindAll @
    @options.template ||= 'vote_for_simple'
    @template = JST[@options.template]

    @model.on 'change', @render
    @render()

  render: ->
    @$el.html @template(rating: @model)
    @$('.tooltip_init').tooltip()
    @
    
  make_vote: (e) ->
    e.preventDefault()

    if @is_authorized()
      user_vote = @model.get 'current_user_vote'
      @direction = $(e.currentTarget).find('input[name="sign"]').attr 'value'

      switch user_vote
        when 1
          if @direction == 'up'
            @model.destroy_vote(@direction)
          else
            @model.create_vote(@direction)

        when -1
          if @direction == 'up'
            @model.create_vote(@direction)
          else
            @model.destroy_vote(@direction)

        when 0
          @model.create_vote(@direction)
