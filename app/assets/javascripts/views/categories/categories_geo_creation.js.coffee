class Smorodina.Views.CategoriesGeoCreation extends Smorodina.Views.Base
  
  el: '#categories-field'

  events:
    'click #list-switcher' : 'toggleList'

  initialize: ->
    super()
    @$container      = @$('#categories-popup')
    @$tag_list_input = @$('#geo_object_tag_list').select2()
    @collection.set 'tag_list_input', @$tag_list_input

    @collection.on 'reset', @render
    @collection.on 'finishPainting', @updateTagSelectList
    @$tag_list_input.on 'change', @updateTagPopupList

    @collection.fetch(reset: true)

  render: ->
    _.each @collection.where(depth: 1), @addOne

  addOne: (model) ->
    category = new Smorodina.Views.Category( model : model )
    @$container.append category.render( visible : true ).el
  
  toggleList: (e)->
    @$container.toggle()
    false

  updateTagSelectList: ->
    tag_list = @collection.activeElements().map (c) => c.get('name')
    @$tag_list_input.select2( 'val', tag_list )
  
  updateTagPopupList: (eventSelect) ->
    console.log eventSelect
    changed_tag = if eventSelect.added? then eventSelect.added.id else eventSelect.removed.id
    @collection.findWhere( name: changed_tag ).updateBySelectTagList()
