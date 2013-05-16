class Smorodina.Views.Votings extends Backbone.View
  el: '.pic_vote'

  events:
    'ajax:beforeSend form' : 'before_ajax_vote'
    'ajax:complete form'   : 'after_ajax_vote'
   
  render: (data)->
    data['rating'] = data.positive - data.negative

    @replace.find('.pic_vote__count').html data['rating']

    @replace.removeClass 'pic_vote_negative'
    @replace.removeClass 'pic_vote_positive'
    @replace.removeClass 'voted_up'
    @replace.removeClass 'voted_down'

    if data['rating'] > 0
      @replace.addClass 'pic_vote_positive'
    if data['rating'] < 0
      @replace.addClass 'pic_vote_negative'

    if data['user_vote'] == 1
      @replace.addClass 'voted_up'
      @replace.find('.pic_vote__up input[name=_method]').attr 'value', 'delete'
      @replace.find('.pic_vote__up form').attr 'action', @unvote_url
    else
      @replace.find('.pic_vote__up input[name=_method]').attr 'value', 'post'
      @replace.find('.pic_vote__up form').attr 'action', @vote_url

    if data['user_vote'] == -1
      @replace.addClass 'voted_down'
      @replace.find('.pic_vote__down input[name=_method]').attr 'value', 'delete'
      @replace.find('.pic_vote__down form').attr 'action', @unvote_url
    else
      @replace.find('.pic_vote__down input[name=_method]').attr 'value', 'post'
      @replace.find('.pic_vote__down form').attr 'action', @vote_url
    
  before_ajax_vote: (evt, xhr, settings)->
    @vote_url = $(evt.currentTarget).attr 'data-vote-url'
    @unvote_url = $(evt.currentTarget).attr 'data-unvote-url'
    @replace = $(evt.currentTarget).parents('.pic_vote').first()
	
  after_ajax_vote: (evt, data, status, xhr)->
    @render(JSON.parse(data.responseText))
    new Smorodina.Views.Votings
