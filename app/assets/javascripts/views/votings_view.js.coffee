class Smorodina.Views.Votings extends Backbone.View
  el: '.pic_vote'

  events:
    'ajax:beforeSend form' : 'before_ajax_vote'
    'ajax:complete form'   : 'after_ajax_vote'
   
  render: (data)->
    #TODO move client-side voting rendering to hamlc
    data['rating'] = data.positive - data.negative

    @replace.find('.pic_vote__count').html data['rating']

    @replace.removeClass 'pic_vote_negative pic_vote_positive voted_up voted_down'

    if data['rating'] > 0
      @replace.addClass 'pic_vote_positive'
    else if data['rating'] < 0
      @replace.addClass 'pic_vote_negative'

    if data['user_vote'] == 1
      @replace.addClass 'voted_up'
      @replace.find('.pic_vote__up form').attr 'action', @unvote_url
      @replace.find('.pic_vote__up input[name=_method]').attr 'value', 'delete'
    else
      @replace.find('.pic_vote__up form').attr 'action', @vote_url
      @replace.find('.pic_vote__up input[name=_method]').attr 'value', 'post'

    if data['user_vote'] == -1
      @replace.addClass 'voted_down'
      @replace.find('.pic_vote__down form').attr 'action', @unvote_url
      @replace.find('.pic_vote__down input[name=_method]').attr 'value', 'delete'
    else
      @replace.find('.pic_vote__down form').attr 'action', @vote_url
      @replace.find('.pic_vote__down input[name=_method]').attr 'value', 'post'
    
  before_ajax_vote: (evt, xhr, settings)->
    @replace = $(evt.currentTarget).parents('.pic_vote').first()
    @vote_url = @replace.attr 'data-vote-url'
    @unvote_url = @replace.attr 'data-unvote-url'

	
  after_ajax_vote: (evt, data, status, xhr)->
    @render(JSON.parse(data.responseText))
    new Smorodina.Views.Votings
