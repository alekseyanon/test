#= require ../collections/events
#= require ./base_view

class Smorodina.Views.EventList extends Smorodina.Views.Base
  el: '#searchResults'
  initialize: ->
    super()
    @$content = @$ '#searchResultsContent'
    @$sectionContent = @$ '#searchResultsDateSectionContent'

    @$spinnerContainer = @$ '#searchResultsSpinner'
    @spinnerContainer = @$spinnerContainer.get 0
    @spinner = new Spinner Smorodina.Config.spinner

    @collection.on 'reset', @render
    @collection.on 'request', @showSpinner
    if @collection.length then @render() else @showSpinner()

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
    @hideSpinner()
    @$fragment = $(null);

    if @collection.length
      @collection.each @addOne
      @$sectionContent.html @$fragment
      @show()
    else
      @hide()

  addOne: (l) ->
    view = new Smorodina.Views.Event(model: l)
    @$fragment = @$fragment.add view.render().el
