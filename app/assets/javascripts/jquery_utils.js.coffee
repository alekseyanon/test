###*
 * jQuery plugin that serialize html form into js object
 * if you don't pass falsyValues argument, then returned
 * object will not contain values of empty inputs.
 *
 * @param {Boolean} falsyValues If returned object should contain values of empty inputs
 * @return {Object} form data serialized into javascript object
###
$.fn.serializeObject = (falsyValues) ->
  formData = this.serializeArray()
  data = {}
  for item in formData
    if Boolean(item.value)
      data[item.name] = item.value
    else if falsyValues
      data[item.name] = item.value
  data

#######################################################################################

class SortControl
  constructor: (@element, options) ->
    @$element = $ @element
    @_init options

  _init: (options) ->
    @options = $.extend {}, $.fn.sortControl.defaults, options
    @selected = @options.selected
    @order = @options.order
    @type = @options.type
    @defaultClass = @options.defaultClass
    @text = @options.text
    @selectedClass =  "#{@defaultClass}_selected"
    @_render()
    @_bindEvents()

  _bindEvents: ->
    @$element.on 'click', $.proxy(@onClick, @)

  _render: ->
    html = "<span class='#{@defaultClass}__text'>#{@text}</span>
            <span class='#{@defaultClass}__arrow'>\u00A0</span>
            <span class='#{@defaultClass}__triangle'></span>"
    @select() if @selected
    @$element
      .html(html)
      .addClass "#{@defaultClass} #{@defaultClass}_#{@order}"

  onClick: ->
    @changeOrder() if @selected
    @select() unless @selected
    @trigger('sort:control', { order: @order, type: @type, control: @ })

  select: ->
    @selected = true
    @$element.addClass @selectedClass
    @

  deselect: ->
    @selected = false
    @$element.removeClass @selectedClass
    @

  changeOrder: ->
    prevOrder = @order
    @order = if @order == 'desc' then 'asc' else 'desc'
    @$element
      .removeClass("#{@defaultClass}_#{prevOrder}")
      .addClass("#{@defaultClass}_#{@order}")

  on: ->
    @$element.on.apply @$element, arguments
    @

  trigger: ->
    @$element.trigger.apply @$element, arguments
    @

$.fn.sortControl = (options) ->
  instance = $.data this[0], 'sortControl'
  unless instance
    instance = new SortControl this[0], options
    $.data this[0], 'sortControl', instance
  instance

$.fn.sortControl.defaults =
  selected: false
  order: 'asc'
  defaultClass: 'sort-control'

#######################################################################################

class SortGroup
  constructor: (@element, @options) ->
    @$element = $ @element
    @_init()

  _init: ->
    for item in @options.controls
      selected = item.type == @options.selected
      control = $('<span>')
        .appendTo(@element)
        .sortControl(
          type: item.type
          text: item.text
          selected: selected )
        .on('sort:control', $.proxy(@onSort, @))
      @selected = control if selected

  onSort: (e, data) ->
    @selected.deselect()
    @selected = data.control.select()
    @trigger 'sort', data

  on: ->
    @$element.on.apply @$element, arguments
    @

  trigger: ->
    @$element.trigger.apply @$element, arguments
    @

$.fn.sortGroup = (options) ->
  instance = $.data this[0], 'sortGroup'
  unless instance
    instance = new SortGroup this[0], options
    $.data this[0], 'sortGroup', instance
  instance

$.fn.sortGroup.options =
  defaultClass: 'sort-control'

