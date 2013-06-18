class Smorodina.Views.CategoriesGeoCreation extends Smorodina.Views.Base
  
  el: '#categories-field'

  events:
    'click #list-switcher' : 'toggleList'

  initialize: ->
    super()

    @$container     = @$('#categories-popup')
    @$tag_list_input = @$selectList.select2()

    @collection.set 'tag_list_input', @$tag_list_input
    @collection.on 'reset', @render
    @collection.on 'finishPainting', @updateTagList
    # TODO:
    # @$tag_list_input.on 'elemAdded' --- update tree
    @collection.fetch(reset: true)

  render: ->
    _.each @collection.where(depth: 1), @addOne

  addOne: (model) ->
    category = new Smorodina.Views.Category( model : model, select )
    @$container.append category.render( visible : true ).el
  
  toggleList: (e)->
    @$container.toggle()
    false

  updateTagList: ->
    # TODO:
    @collection.activeElements.each (e)=>
      @$tag_list_input.select2( add: e.text )
