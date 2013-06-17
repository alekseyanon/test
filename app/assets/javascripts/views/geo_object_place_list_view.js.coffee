class Smorodina.Views.GeoObjectPlaceList extends Smorodina.Views.Base
  el: '.place_objects'
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
  
  sortByName: ->
    sort=@currentSortN
    @collection.comparator = (objA, objB) ->
      return -sort  if objA.get("title") > objB.get("title")
      return sort  if objB.get("title") > objA.get("title")
      0
    @currentSortN*=-1
    @$sortbyR.find('.direction').html ''
    @$sortbyR.removeClass('btn').addClass('unselected')
    @$sortbyN.addClass('btn').removeClass('unselected')
    if @currentSortN<0
      @$sortbyN.find('.direction').html '&darr;'
    else
      @$sortbyN.find('.direction').html '&uarr;'
    @collection.sort()
  
  sortByRating: ->
    sort=@currentSortR
    @collection.comparator = (objA, objB) ->
      return -sort  if objA.get("average_rating") > objB.get("average_rating")
      return sort  if objB.get("average_rating") > objA.get("average_rating")
      0
    @currentSortR*=-1
    @$sortbyN.find('.direction').html ''
    @$sortbyN.removeClass('btn').addClass('unselected')
    @$sortbyR.addClass('btn').removeClass('unselected')
    if @currentSortR<0
      @$sortbyR.find('.direction').html '&darr;'
    else
      @$sortbyR.find('.direction').html '&uarr;'
    @collection.sort()
  
  addOne: (l) ->
    view = new Smorodina.Views.GeoObjectPlace(model: l)
    @$fragment = @$fragment.add view.render().el
  