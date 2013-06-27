class Smorodina.Views.CategoriesGeoCreation extends Smorodina.Views.Base
  
  el: '#categories-field'

  events:
    'click #list-switcher' : 'toggleList'

  initialize: ->
    super()
    @$container      = @$('#categories-popup')
    @$tag_list_input = @$('#geo_object_tag_list').select2()

    @collection.on 'reset', @render
    @collection.on 'updateSelectionList', @updateSelectionList

    @collection.fetch(reset: true)

  render: ->
    _.each @collection.where(depth: 1), @addOne
    @collection.markLeafs()

  addOne: (model) ->
    category = new Smorodina.Views.Category( model : model )
    @$container.append category.render( visible : true ).el
  
  toggleList: ->
    @$container.toggle()
    @collection.fromListToTree( @$tag_list_input.select2('val') ) if @$container.is(':visible')
    false

  updateSelectionList: ->
    tag_list = @collection.activeElements().map (c) -> c.get('name')
    @$tag_list_input.select2( 'val', tag_list )
