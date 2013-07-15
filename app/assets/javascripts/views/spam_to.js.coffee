class Smorodina.Views.SpamToView extends Smorodina.Views.Base
  template: JST['spam_to']

  initialize: ->
    super()
    @complaint = @options.complaint
    @render()

  afterRender: ->
    @$('.tooltip_init').tooltip()

  render: ->
    @$el.html @template(complaint: @complaint)
    @$('.tooltip_init').tooltip()
    @
