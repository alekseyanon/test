class Smorodina.Views.VoteForSimple extends Backbone.View
  template: JST['vote_for_simple']

  el: '.pic_vote.simple'

  events:
    'submit form' : 'make_vote' 

  initialize: ->
    _.bindAll this, "render"
    @path = $(@el).attr 'data-vote_url'
    @model = new Backbone.Model [], {url: @path, id: null, sign: ''}
    @model.on 'sync', @render 

  render: ->
    values = $.parseJSON @result.responseText
    rating =
      vote_url: @path
      current_user_vote: values.user_vote
      votes_for: values.positive
      votes_against: values.negative
    
    rendered = @template rating: rating
    old_element = $(@el) 
    new_element = $(rendered)
    @setElement new_element

    old_element.replaceWith new_element
    @

  make_vote: (e) ->
    e.preventDefault()
    @user_vote = $(@el).attr 'data-user_vote'
    @direction = $(e.currentTarget).find('input[name="sign"]').attr 'value'

    switch @user_vote
      when '1'
        if @direction == 'up'
          @destroy_vote()

        if @direction == 'down'
          @create_vote()

      when '-1'
        if @direction == 'up'
          @create_vote()

        if @direction == 'down'
          @destroy_vote()

      when '0'
        @create_vote()

  destroy_vote: ->
    @model.set sign: @direction, id: '500'
    @result = @model.destroy()

  create_vote: ->
    @model.set sign: @direction, id: null
    @result = @model.save()

