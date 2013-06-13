class Smorodina.Views.CommentsListView extends Smorodina.Views.Base
  className: 'pic_comments__container'

  template: JST['comments_list']

  parent_id: null

  events: 
    'submit .pic_comments__add form' : 'create_new' 

  initialize: ->
    _.bindAll @

    @parent_id = @options.parent_id
    @hash = @options.hash
    
    @collection.on 'add', @render_one

  hide: ->
    @$el.css display: 'none'
    @
      
  build: ->
    @collection.fetch
      el: @
      success: (collection, response, options)->
        options.el.trigger 'ready'


  render_collection: ->
    @$el.html @template parent_id: @parent_id, hash: @hash
    _.each @collection.models, @render_one
    @trigger 'ready'
    @

  render: ->
    @$el.html @template parent_id: @parent_id, hash: @hash
    @

  render_one: (record)->
    if (record.get('parent_id') == null && @parent_id == null) || (record.get('parent_id') == @parent_id)
      view = new Smorodina.Views.CommentView model: record, collection: @collection
      @$el.find('.pic_comments__list').first().append view.render().el


  create_new: (e)->
    e.preventDefault()

    if @is_authorized() && @parent_id == null
      values = $(e.currentTarget).serializeArray()
      data =
        parent_id: values[0].value
        body: values[1].value

      @collection.create data,
        el: $(e.currentTarget)
        wait: true
        success: (model, resp, opt)->
          opt.el[0].reset()
          if model.get('parent_id')
            opt.el.parents('.pic_comments__add').slideUp()
