class Smorodina.Views.VoteForSimple extends Backbone.View
  template: JST['vote_for_simple']

  el: '.pic_vote.simple'

  events:
    'submit form' : 'make_vote' 

  initialize: ->
    _.bindAll this, "render"
    
  render: ->
    values = $.parseJSON @result.responseText
    rating =
      vote_url: @path
      current_user_vote: values.user_vote
      votes_for: values.positive
      votes_against: values.negative
    
    rendered = @template rating: rating

    @replace.html $(rendered).html()
    @replace.attr 'data-vote_url', $(rendered).attr 'data-vote_url'
    @replace.attr 'data-user_vote', $(rendered).attr 'data-user_vote'
    @replace.attr 'class', $(rendered).attr 'class'
    @

  make_vote: (e) ->
    e.preventDefault()
    @replace = $(e.currentTarget).parents('.pic_vote.simple').first()
    @direction = $(e.currentTarget).find('input[name="sign"]').attr 'value'
    @path = @replace.attr 'data-vote_url'
    @user_vote = @replace.attr 'data-user_vote'
    @model = new Backbone.Model [], {url: @path, id: null, sign: ''}
    @model.on 'sync', @render 

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

