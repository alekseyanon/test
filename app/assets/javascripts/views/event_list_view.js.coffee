#= require collections/events
#= require ./base_view

class Smorodina.Views.EventList extends Smorodina.Views.Base
  el: '#searchResults'
  initialize: ->
    super()
    @$content = @$ '#searchResultsContent'
    @$spinnerContainer = @$ '#searchResultsSpinner'
    @spinnerContainer = @$spinnerContainer.get 0
    @spinner = new Spinner Smorodina.Config.spinner

    @collection.on 'reset', @render
    @collection.on 'request', @showSpinner
    @collection.on 'sort', @render
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

  changeTemplate: ->
    if @collection.sortProp == 'rating'
      @template = JST['event_list']
    else if @collection.sortProp == 'date'
      @template = JST['event_list_grouped_by_date']

  render: ->
    @changeTemplate()
    @hideSpinner()
    if @collection.length
      @$content.html @template(@collection.getGrouped())
      @show()
    else
      @hide()
