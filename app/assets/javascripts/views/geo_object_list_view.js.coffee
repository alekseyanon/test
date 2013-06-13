#= require ../collections/geo_objects
#= require ./base_view

class Smorodina.Views.GeoObjectList extends Smorodina.Views.Base
  el: '#searchResults'
  initialize: ->
    super()
    @$content = @$ '#searchResultsContent'
    @$bestContent = @$ '#searchResultsBestContent'
    @$restContent = @$ '#searchResultsRestContent'

    @$spinnerContainer = @$ '#searchResultsSpinner'
    @spinnerContainer = @$spinnerContainer.get 0
    @spinner = new Spinner Smorodina.Config.spinner

    @collection.on 'reset', @render
    @collection.on 'request', @showSpinner

  showSpinner: ->
    @show()
    @$content.hide()
    @$spinnerContainer.show()
    @spinner.spin @spinnerContainer

  hideSpinner: ->
    @$content.show()
    @$spinnerContainer.hide()
    @spinner.stop()

  render: ->
    switch @collection.length
      when 0 then @hide()
      when 1 then @redirect_to_exact_one(@collection.first())
      else 
        @hideSpinner()
        @$fragment = $(null)
        @collection.each @addOne
        # TODO this is temorary solution only for demonstration
        @$bestContent.html @$fragment.slice(0,4)
        @$restContent.html @$fragment.slice(4)
        @show()


  addOne: (l) ->
    view = new Smorodina.Views.GeoObject(model: l)
    @$fragment = @$fragment.add view.render().el
  
  redirect_to_exact_one: (geo_object) ->
    window.location.href = window.location.href.replace(/search/, geo_object.id) 
