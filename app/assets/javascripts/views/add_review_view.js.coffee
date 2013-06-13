#= require ./base_view
class Smorodina.Views.AddReviewView extends Smorodina.Views.Base
  className: 'review_form'

  template: JST['add_review']

  review_template: JST['review']

  model: new Backbone.Model()

  events: 
    'click #create_review_preview' : 'build_review'

  initialize: ->
    _.bindAll @


  render: ->
    @$el.html @template
    @$('.redactor').first().redactor(Smorodina.Config.redactor)
    @

  build_review: (e)->
    e.preventDefault()
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

