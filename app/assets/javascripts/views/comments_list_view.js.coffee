class Smorodina.Views.CommentsListView extends Smorodina.Views.Base
  className: 'pic_comments__container'

  template: JST['comments_list']

  parent_id: null

  events: 
    'submit .pic_comments__add form' : 'create_new' 

  initialize: ->
    _.bindAll @
    @parent_id = @options.parent_id
    @collection.on 'add', @render_one
    if !@collection.length
      @collection.fetch()

  render_collection: ->
    @$el.html @template parent_id: @parent_id
    _.each @collection.models, @render_one
    @


  render: ->
    @$el.html @template parent_id: @parent_id
    @

  render_one: (record)->
    if (record.get('parent_id') == null && @parerent_id == null) || (record.get('parent_id') == @parent_id)
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
