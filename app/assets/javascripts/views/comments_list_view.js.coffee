class Smorodina.Views.CommentsListView extends Backbone.View
  className: 'pic_comments__container'
  parent_id: null
  template: JST['comments_list']
  
  initialize: ->
    _.bindAll @
    @parent_id = @options.parent_id
    if !@collection.length
      @collection.on 'add', @render_one
      @collection.fetch()

  render: ->
    @$el.html @template 
    @

  render_one: (record)->
    view = new Smorodina.Views.CommentView model: record, collection: @collection
    @$el.find('.pic_comments__list').append view.render().el


  create_new: (e)->
    e.preventDefault()
    data =
      body: @$el.find('.pic_comments__add__input input').val()

    @collection.create data,
      wait: true,
      success: ->
        $('.obj_descr__text__descr__how_to_reach__list__add form')[0].reset()
      error: ->
        @handleCreationError
                                                                     

  handleCreationError: ->
    console.log 'Some errors happened!'
