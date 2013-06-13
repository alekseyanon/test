#= require ./base_view
class Smorodina.Views.AddReviewView extends Smorodina.Views.Base
  className: 'review_form'

  template: JST['add_review']

  review_template: JST['review']

  model: new Backbone.Model()

  title_max_length: 100
  body_min_length: 100

  events: 
    'click #create_review_preview' : 'build_review'
    'click #edit_review'     : 'edit_review'
    'keydown #new_review_title': 'title_changing'
    'keydown .redactor_editor': 'body_changing'

  initialize: ->
    _.bindAll @


  render: ->
    @$el.html @template
    @$('.redactor').first().redactor(Smorodina.Config.redactor)
    @title_changing()
    @body_changing()
    @

  build_review: (e)->
    e.preventDefault()
    
    #TODO: rework this width validation
    title_length = @$('#new_review_title').val().length
    body_length = parseInt @$('#new_review_body').val().length
    if title_length > @title_max_length || body_length < @body_min_length
      return

    user_data = 
      username: $('div.user-panel').attr 'data-user_name'
      link_to_profile: '#'
      avatar: '/my_profile/avatar'

    rating_data =
      votes_for: 0,
      votes_against: 0,
      current_user_vote: 0,
      vote_url: '#',

    complaints_data = 
      url: '#',
      current_user: 0


    @model.set 'title', @$('#new_review_title').val()
    @model.set 'body', @$('#new_review_body').val()
    @model.set 'id', 0
    @model.set 'comments_count', '0 комментариев'
    @model.set 'user', user_data
    @model.set 'rating', rating_data
    @model.set 'complaint', complaints_data
    @model.set 'date', $('div.user-panel').attr 'data-date'

    view = new Smorodina.Views.ReviewView model: @model, real: false

    @$('.obj_descr__responces__add_review__preview__content').html view.render().el
    @$('.obj_descr__responces__add_review__form').slideToggle()
    @$('.obj_descr__responces__add_review__preview').slideToggle()

  edit_review: (e)->
    e.preventDefault()
    @$('.obj_descr__responces__add_review__form').slideToggle()
    @$('.obj_descr__responces__add_review__preview').slideToggle()

  title_changing: (e)->
    title_length = @$('#new_review_title').val().length
    symb_left = @title_max_length - title_length
    colored = @$('span.colored.title')
    if symb_left < 0
      symb_left = 0

    if title_length
      if title_length < @title_max_length
        colored.removeClass('positive negative').addClass 'positive'
      else 
        colored.removeClass('positive negative').addClass 'negative'
        e.preventDefault()

    colored.html "Осталось #{symb_left} символов"


  body_changing: (e)->
    body_length = parseInt @$('#new_review_body').val().length
    colored = @$('span.colored.body')
   
    if body_length > 0
      if body_length > @body_min_length
        colored.removeClass('positive negative').addClass 'positive'
      else 
        colored.removeClass('positive negative').addClass 'negative'

    colored.html "заполнено #{body_length}"



