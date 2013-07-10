class Smorodina.Views.GeoObjectPlaceList extends Smorodina.Views.Base

  el: '.place_objects'

  events: 
    'click button.search-category' : 'applyFilter'

  initialize: ->
    super()
    _.bindAll @
    @$content = @$ '#place_object_list'
    @$sortbyN = @$ '.by_name'
    @$sortbyR = @$ '.by_rating'
    @currentSortN = -1
    @currentSortR = -1
    @$sortbyN.on 'click', @sortByName
    @$sortbyR.on 'click', @sortByRating
    @collection.on 'sync sort reset', @render
    @collection.fetch()
    
  render: ->
    @$fragment = $(null);

    if @collection.length
      @collection.each @addOne
      @show()
    else
      @hide()
    @$content.html @$fragment
    @countObjectsInCategories()
  
  countObjectsInCategories: ->
    for tag in @collection.countTags()
      @$("#filter_#{tag.name}").text tag.count

  sortByName: ->
    @currentSortN*=-1
    sort=@currentSortN
    @collection.comparator = (objA, objB) ->
      return -sort  if objA.get("title") > objB.get("title")
      return sort  if objB.get("title") > objA.get("title")
      0
    @$sortbyR.find('.direction').html ''
    @$sortbyR.removeClass('btn').addClass('unselected')
    @$sortbyN.addClass('btn').removeClass('unselected')
    @$sortbyN.find('.direction').html if @currentSortN<0 then '&darr;' else '&uarr;'
    @collection.sort()
  
  sortByRating: ->
    @currentSortR*=-1
    sort=@currentSortR
    @collection.comparator = (obj) ->
      sort * obj.get("average_rating")
    @$sortbyN.find('.direction').html ''
    @$sortbyN.removeClass('btn').addClass('unselected')
    @$sortbyR.addClass('btn').removeClass('unselected')
    @$sortbyR.find('.direction').html if @currentSortR<0 then '&darr;' else '&uarr;'
    @collection.sort()
  
  addOne: (item) ->
    view = new Smorodina.Views.GeoObjectPlace(model: item)
    @$fragment = @$fragment.add view.render().el

  applyFilter: (e)->
    target = $(e.target).closest('.search-category')
    @collection.applyFilter( target.attr('data-facet') )
